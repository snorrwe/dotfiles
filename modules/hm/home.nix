{
  pkgs,
  lib,
  config,
  username,
  inputs,
  features,
  ...
}:
{
  home = {
    # Home Manager Settings
    username = "${username}";
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
    stateVersion = "26.05";
    packages = with pkgs; [
      parallel
      unzip
      zip
      dust # nicer du alternative
      go
      just
      watchexec
      ninja
      starship # for my shell prompt
      cmake
      gzip
      diffutils
      github-cli
      git-lfs
      nodejs_22
      curl

      rustup
      cargo-binstall
      cargo-nextest
      cargo-watch
      cargo-clean-recursive
      # topgrade deps to manage cargo-installed packages
      cargo-update
      cargo-cache

      pkg-config
      sccache
      visidata
      units
      killall
      podman-compose
      docker-compose
      devenv
      nixfmt

      clang
      clang-tools

      flamegraph
      sleek # SQL formatter

      tokei # count LOC
      dysk # show disk usage, nicer default format than df

      hyperfine # cli benchmarking tool
      sshfs
      python3
    ];
  };

  imports = [
    ./git.nix
    ./fastfetch.nix
    ./nushell.nix
    ./cli.nix
    ./setup-git-repos.nix
    ./nvim.nix
    ./yazi.nix
    ./scripts.nix
    ./nh.nix
    ./btop.nix
    ./syncthing.nix
    ./symlinks.nix
    ./tmux.nix
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    ./rice.nix
    ./dunst.nix
    ./mime.nix
    ./lockscreen.nix
    ./waybar.nix
    ./wlogout.nix
    ./fuzzel.nix
    ./distrobox.nix
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
      extraConfig = builtins.readFile ../../.wezterm.lua;
      package = inputs.wezterm.packages.${pkgs.stdenv.hostPlatform.system}.default or pkgs.wezterm;
    };

    # media player, used by yazi by default
    mpv = {
      enable = features.enableGui;
    };
  };
}
