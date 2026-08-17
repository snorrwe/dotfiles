{
  pkgs,
  username,
  inputs,
  features,
  config,
  ...
}:
let
  inherit (pkgs.lib.lists) optionals;
in
{
  home = {
    # Home Manager Settings
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "26.05";
    packages =
      with pkgs;
      [
        go
        ninja
        cmake
        gzip
        nodejs_22
        curl

        pkg-config
        visidata
        killall
        podman-compose
        docker-compose

        clang
        clang-tools

        flamegraph

        sshfs
        python3
      ]
      ++ (optionals features.enableGui [ libnotify ]);
  };

  imports = [
    ./parallel.nix
    ./rice.nix
    ./dunst.nix
    ./mime.nix
    ./cli.nix
    ./lockscreen.nix
    ./setup-git-repos.nix
    ./waybar.nix
    ./wlogout.nix
    ./fuzzel.nix
    ./scripts.nix
    ./symlinks.nix
    ./distrobox.nix
    ./tasknotes.nix
    ./sccache.nix
    inputs.agenix.homeManagerModules.default
  ];
  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    topgrade = {
      enable = true;
      package = pkgs.topgrade;
      settings = {
        misc = {
          assume_yes = true;
          cleanup = true;
          disable = [
            "system"
            "nix"
            "home_manager"
            "rustup"
          ];
          skip_notify = false;
          pre_sudo = true;
        };
        git = {
          repos = [
            "${config.home.homeDirectory}/.local/share/zsh-snap"
          ];
          arguments = "--rebase --autostash";
        };
      };

    };
    wezterm = {
      enable = features.enableGui;
      enableZshIntegration = true;
      extraConfig = builtins.readFile ../../dotfiles/.wezterm.lua;
      package = inputs.wezterm.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };

    # media player, used by yazi by default
    mpv = {
      enable = features.enableGui;
    };
  };

  age.identityPaths = [
    "${config.home.homeDirectory}/.ssh/id_ed25519"
    "${config.home.homeDirectory}/.ssh/home"
  ];
}
