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
  exportBin = pkgs.writeShellScriptBin "agent-box-export" (
    builtins.readFile ./agent-scripts/agent-box-export
  );
  notifyBin = pkgs.writeShellScriptBin "agent-notify-send" (
    builtins.readFile ./agent-scripts/agent-notify-send
  );
  renameBin = pkgs.writeShellScriptBin "agent-tmux-rename-window" (
    builtins.readFile ./hm/scripts/tmux-rename-window
  );
  hostActions = pkgs.writeShellScript "agent-host-actions" (
    builtins.readFile ./agent-scripts/agent-host-actions
  );
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
  # Publish bound TCP ports on host loopback only. Podman splits the suffix on commas.
  # --host-lo-to-ns-lo keeps servers bound to 127.0.0.1 inside the box reachable.
  # --map-guest-addr none removes the host.containers.internal path onto the host.
  networkMode = "pasta:--host-lo-to-ns-lo,--map-guest-addr,none,-t,127.0.0.1/auto,-t,::1/auto,-u,none,-T,none,-U,none";
  # Kept in the spec hash so boxes already created with this parent are not recreated.
  cgroupSlice = "agent.slice";
  # Pasta is started via sg(1) in this group. nft matches meta skgid, which does not
  # need the cgroup to exist at load time (socket cgroupv2 resolves a path then).
  egressGroup = "agent-box";
  # Skip host.containers.internal even if Podman still prefers the pasta guest address.
  containersConf = pkgs.writeText "agent-box-containers.conf" ''
    [containers]
    host_containers_internal_ip = "none"
  '';
  # A native nft table, not networking.nftables.enable: that module blacklists
  # ip_tables, which rootless Docker in modules/containers.nix still needs.
  egressRules = pkgs.writeText "agent-box-egress.nft" ''
    table inet agentbox
    delete table inet agentbox
    table inet agentbox {
      chain output {
        type filter hook output priority filter; policy accept;
        meta skgid "${egressGroup}" meta l4proto { tcp, udp } th dport 53 ip daddr 127.0.0.0/8 accept
        meta skgid "${egressGroup}" meta l4proto { tcp, udp } th dport 53 ip6 daddr ::1 accept
        meta skgid "${egressGroup}" ip daddr {
          10.0.0.0/8,
          172.16.0.0/12,
          192.168.0.0/16,
          100.64.0.0/10,
          169.254.0.0/16,
          127.0.0.0/8
        } reject with icmpx type admin-prohibited
        meta skgid "${egressGroup}" ip6 daddr {
          fc00::/7,
          fe80::/10,
          ::1
        } reject with icmpx type admin-prohibited
      }
    }
  '';
  langfuseSecret = config.home-manager.users.${username}.age.secrets.langfuse-json.path;
  spec = builtins.hashString "sha256" (
    builtins.toJSON {
      inherit mounts networkMode cgroupSlice;
      hostContainersInternal = "none";
      hostBin = "/home/${username}/.local/bin";
      # Invalidate boxes created with per-directory/transient mount semantics.
      workspaceMode = "declared-only";
      image = toString image;
      # Recreate when Langfuse secret wiring changes (path only; never values).
      langfuseSecret = toString langfuseSecret;
    }
  );
  agentBox = pkgs.writeShellApplication {
    name = "agent-box";
    runtimeInputs = with pkgs; [
      config.virtualisation.podman.package
      coreutils
      jq
      util-linux
    ];
    # Keep build-time values shell-escaped and separate from launcher logic.
    text = ''
      agent_spec=${lib.escapeShellArg spec}
      agent_network_mode=${lib.escapeShellArg networkMode}
      # Setgid wrapper. sg(1) is not setuid here, so setgroups fails.
      agent_exec=${lib.escapeShellArg "${config.security.wrapperDir}/agent-box-exec"}
      agent_containers_conf=${lib.escapeShellArg containersConf}
      export CONTAINERS_CONF_OVERRIDE="$agent_containers_conf"
      agent_image=${lib.escapeShellArg "${image.imageName}:${image.imageTag}"}
      agent_image_archive=${lib.escapeShellArg (toString image)}
      agent_policy=${lib.escapeShellArg (toString config.environment.etc."containers/policy.json".source)}
      agent_activation=${lib.escapeShellArg (toString agentHome.activationPackage)}
      # HM agenix paths embed ''${XDG_RUNTIME_DIR}; leave unescaped so the shell expands it.
      langfuse_secret=${langfuseSecret}
      configured_sources=(${lib.escapeShellArgs (map (m: m.hostPath) mounts)})
      configured_targets=(${lib.escapeShellArgs (map (m: m.containerPath) mounts)})
      configured_read_only=(${lib.escapeShellArgs (map (m: lib.boolToString m.readOnly) mounts)})
    ''
    + builtins.readFile ./agent-scripts/agent-box;
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

    environment.systemPackages = [ pkgs.nftables ];

    # The image tarball is gzip-compressed, so the Nix scanner does not see the
    # /usr/local/bin symlinks inside it. Without this, nix-collect-garbage
    # deletes these tools, and the running container keeps the dangling links.
    system.extraDependencies = [
      exportBin
      notifyBin
      renameBin
      pkgs.socat
      agentHome.config.home.path
    ];

    users.groups.${egressGroup} = { };
    users.users.${username}.extraGroups = [ egressGroup ];

    # Exec the podman binary directly. A shell would drop the setgid egid.
    security.wrappers.agent-box-exec = {
      source = lib.getExe config.virtualisation.podman.package;
      owner = "root";
      group = egressGroup;
      setuid = false;
      setgid = true;
    };

    systemd = {
      services.agent-box-egress = {
        description = "Reject agent-box pasta connections into private networks";
        wantedBy = [ "multi-user.target" ];
        after = [ "systemd-sysusers.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.nftables}/bin/nft -f ${egressRules}";
          ExecStop = "${pkgs.nftables}/bin/nft delete table inet agentbox";
        };
      };
      user = {
        slices.agent = {
          description = "agent-box containers and their pasta processes";
        };
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
          Environment = "PATH=${
            lib.makeBinPath [
              pkgs.tmux
              pkgs.libnotify
            ]
          }";
          StandardInput = "socket";
          StandardOutput = "socket";
          TimeoutStartSec = "6s";
        };
      };
    };

    home-manager.users.${username} = {
      # Host Home Manager decrypts this; agent-box injects LANGFUSE_* into the box.
      age.secrets.langfuse-json.file = ./secrets/langfuse.json;
      home.packages = [ agentBox ];
    };
  };
}
