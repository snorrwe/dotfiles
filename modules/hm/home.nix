{
  pkgs,
  username,
  host,
  inputs,
  ...
}:
{
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    tmux
    stow
    parallel
    unzip
    zip
    dust # nicer du alternative
    go
    just
    watchexec
    lazygit
    ninja
    starship # for my shell prompt
    pipx
    btop
    cmake
    gzip
    diffutils
    github-cli
    git-lfs
    nodejs_22

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
    nixfmt-rfc-style

    clang-tools
    clang

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
    ./xdg.nix
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
          "git_repos"
          "nix"
        ];
        skip_notify = false;
        pre_sudo = true;
      };
    };

  };
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = builtins.readFile ../../dot-wezterm.lua;
    package = inputs.wezterm.packages.${pkgs.system}.default;
  };

}
