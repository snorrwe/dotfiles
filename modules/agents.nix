{
  agentHome,
  config,
  features,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.dotfiles.agents;
  # Pin the x86_64 Fedora 43 manifest, not its mutable registry tag.
  fedoraBase = pkgs.dockerTools.pullImage {
    imageName = "registry.fedoraproject.org/fedora";
    imageDigest = "sha256:332eeed639be43075ecd07e3c0ba117b1ad95a0e58bf96defb0a8e255990a03c";
    hash = "sha256-w3bzPE4fd+QQovXkHkld8GtpRUkCo4g04N57kJZ4xLw=";
    finalImageName = "registry.fedoraproject.org/fedora";
    finalImageTag = "43";
  };
  exportBin = pkgs.writeShellScriptBin "agent-box-export" (builtins.readFile ./agent-scripts/agent-box-export);
  notifyBin = pkgs.writeShellScriptBin "agent-notify-send" (builtins.readFile ./agent-scripts/agent-notify-send);
  renameBin = pkgs.writeShellScriptBin "agent-tmux-rename-window" (
    builtins.readFile ./hm/scripts/tmux-rename-window
  );
  hostActions = pkgs.writeShellScript "agent-host-actions" (builtins.readFile ./agent-scripts/agent-host-actions);
  # Home Manager provides general tools. Keep only container helpers here;
  # privileged programs such as sudo must come from Fedora, not the Nix store.
  agentTools = pkgs.runCommand "agent-tools" { } ''
    mkdir -p $out/usr/local/bin
    ln -s ${pkgs.socat}/bin/socat $out/usr/local/bin/socat
    ln -s ${exportBin}/bin/agent-box-export $out/usr/local/bin/agent-box-export
    ln -s ${notifyBin}/bin/agent-notify-send $out/usr/local/bin/notify-send
    ln -s ${renameBin}/bin/agent-tmux-rename-window $out/usr/local/bin/tmux-rename-window
  '';
  image = pkgs.dockerTools.buildLayeredImage {
    name = "agent";
    # Let dockerTools derive the tag from the entire image configuration.
    fromImage = fedoraBase;
    contents = [ agentTools ];
    extraCommands = ''
      mkdir -p home/agent nix/var/nix workspace etc/profile.d
      # Fedora's login shell resets PATH; restore the agent's own tools too.
      printf '%s\n' 'export PATH="/usr/local/bin:$PATH:${agentHome.config.home.path}/bin"' > etc/profile.d/agent-tools.sh
    '';
    config = {
      Env = [
        "PATH=/usr/local/bin:/usr/bin:/bin:${agentHome.config.home.path}/bin"
        "HOME=/home/agent"
        "EDITOR=nvim"
        "NIX_REMOTE=daemon"
        "SSL_CERT_FILE=/etc/pki/tls/certs/ca-bundle.crt"
        "USER=${username}"
        "LOGNAME=${username}"
      ];
      WorkingDir = "/home/agent";
      Cmd = [
        "/usr/bin/sleep"
        "infinity"
      ];
    };
  };
  mounts = cfg.sharedDirectories;
  spec = builtins.hashString "sha256" (
    builtins.toJSON {
      inherit mounts;
      hostBin = "/home/${username}/.local/bin";
      # Invalidate boxes created with per-directory/transient mount semantics.
      workspaceMode = "declared-only";
      image = toString image;
    }
  );
  agentBox = pkgs.writeShellApplication {
    name = "agent-box";
    runtimeInputs = with pkgs; [
      config.virtualisation.podman.package
      coreutils
      util-linux
    ];
    # Keep build-time values shell-escaped and separate from launcher logic.
    text = ''
      agent_spec=${lib.escapeShellArg spec}
      agent_image=${lib.escapeShellArg "${image.imageName}:${image.imageTag}"}
      agent_image_archive=${lib.escapeShellArg (toString image)}
      agent_policy=${lib.escapeShellArg (toString config.environment.etc."containers/policy.json".source)}
      agent_activation=${lib.escapeShellArg (toString agentHome.activationPackage)}
      configured_sources=(${lib.escapeShellArgs (map (m: m.hostPath) mounts)})
      configured_targets=(${lib.escapeShellArgs (map (m: m.containerPath) mounts)})
      configured_read_only=(${lib.escapeShellArgs (map (m: lib.boolToString m.readOnly) mounts)})
    '' + builtins.readFile ./agent-scripts/agent-box;
  };
in
{
  options.dotfiles.agents.sharedDirectories = lib.mkOption {
    default = [ ];
    type = lib.types.listOf (
      lib.types.submodule {
        options = {
          hostPath = lib.mkOption {
            type = lib.types.str;
            description = "Absolute, non-symlinked host directory to share with agents.";
          };
          containerPath = lib.mkOption {
            type = lib.types.str;
            description = "Absolute target under /workspace in the agent container.";
          };
          readOnly = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
        };
      }
    );
    description = "Explicit directories shared with the agent container; empty by default.";
  };

  config = lib.mkIf features.enableAgents {
    assertions = [
      {
        assertion = lib.all (
          m:
          lib.hasPrefix "/" m.hostPath
          && !(lib.hasInfix "/.." m.hostPath)
          && !(lib.elem m.hostPath [
            "/"
            "/home"
            "/home/${username}"
            "/nix"
            "/etc"
            "/run"
            "/var"
          ])
        ) mounts;
        message = "Agent host mounts must be absolute directories, not broad roots or contain '..'.";
      }
      {
        assertion =
          lib.all (
            m:
            lib.hasPrefix "/workspace/" m.containerPath
            && !(lib.hasInfix "/.." m.containerPath)
            && m.containerPath != "/workspace/current"
            && !(lib.hasPrefix "/workspace/current/" m.containerPath)
            && lib.all (
              other:
              other.containerPath == m.containerPath || !(lib.hasPrefix "${m.containerPath}/" other.containerPath)
            ) mounts
          ) mounts
          && lib.length (lib.unique (map (m: m.containerPath) mounts)) == lib.length mounts;
        message = "Agent mount targets must be distinct, avoid /workspace/current, and stay under /workspace.";
      }
    ];

    virtualisation.podman.extraPackages = [ pkgs.slirp4netns ];

    systemd = {
      user = {
        sockets.agent-host-actions = {
          wantedBy = [ "sockets.target" ];
          socketConfig = {
            ListenStream = "%t/agent-host-actions.sock";
            SocketMode = "0600";
            RemoveOnStop = true;
            Accept = true;
          };
        };
        services."agent-host-actions@".serviceConfig = {
          ExecStart = hostActions;
          Environment = "PATH=${lib.makeBinPath [ pkgs.tmux pkgs.libnotify ]}";
          StandardInput = "socket";
          StandardOutput = "socket";
          TimeoutStartSec = "6s";
        };
      };
    };

    home-manager.users.${username}.home.packages = [ agentBox ];
  };
}
