{
  pkgs,
  username,
  inputs,
  features,
  ...
}:
{
  home = {
    # Home Manager Settings
    username = "${username}";
    homeDirectory = "/home/${username}";
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

      pkg-config
      sccache
      visidata
      units
      killall
      podman-compose
      docker-compose
      devenv

      clang
      clang-tools

      flamegraph

      tokei # count LOC
      dysk # show disk usage, nicer default format than df

      hyperfine # cli benchmarking tool
      sshfs
      python3
    ];
  };

  imports = [
    ./rice.nix
    ./dunst.nix
    ./git.nix
    ./mime.nix
    ./fastfetch.nix
    ./nushell.nix
    ./cli.nix
    ./lockscreen.nix
    ./setup-git-repos.nix
    ./nvim.nix
    ./waybar.nix
    ./wlogout.nix
    ./fuzzel.nix
    ./yazi.nix
    ./scripts.nix
    ./nh.nix
    ./btop.nix
    ./symlinks.nix
    ./tmux.nix
    ./distrobox.nix
    ./direnv.nix
    ./rust.nix
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
            "/home/${username}/.local/share/zsh-snap"
          ];
          arguments = "--rebase --autostash";
        };
      };

    };
    wezterm = {
      enable = features.enableGui;
      enableZshIntegration = true;
      extraConfig = builtins.readFile ../../dot-config/.wezterm.lua;
      package = inputs.wezterm.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };

    # media player, used by yazi by default
    mpv = {
      enable = features.enableGui;
    };
  };
}
