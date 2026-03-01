{
  pkgs,
  username,
  inputs,
  features,
  ...
}:
{
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.05";
  home.packages = with pkgs; [
    tmux
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
    glow # tui markdown reader/renderer
    units
    killall
    podman-compose
    docker-compose
    devenv
    mutagen
    pandoc
    nixfmt

    clang
    clang-tools

    flamegraph
    sleek # SQL formatter

    tokei # count LOC
    dysk # show disk usage, nicer default format than df

    hyperfine # cli benchmarking tool
    sshfs
    fzf
    python3

    # yazi deps
    ueberzugpp
  ];

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
    ./syncthing.nix
    ./symlinks.nix
    ./tmux.nix
    ./distrobox.nix
  ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.topgrade = {
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
  programs.wezterm = {
    enable = features.enableGui;
    enableZshIntegration = true;
    extraConfig = builtins.readFile ../../.wezterm.lua;
    package = inputs.wezterm.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };

  # media player, used by yazi by default
  programs.mpv = {
    enable = features.enableGui;
  };
}
