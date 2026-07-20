{
  pkgs,
  username,
  ...
}:
{
  home = {
    username = "${username}";
    homeDirectory = "/Users/${username}";
    stateVersion = "26.05";
    packages = with pkgs; [
      parallel
      unzip
      zip
      dust # nicer du alternative
      just
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

      tokei # count LOC
      hyperfine # cli benchmarking tool
      sshfs
      python3
    ];
  };

  imports = [
    ./git.nix
    ./nushell.nix
    ./cli.nix
    ./nvim.nix
    ./scripts.nix
    ./nh.nix
    ./tmux.nix
    ./direnv.nix
    ./yazi.nix
    ./symlinks.nix
    ./setup-git-repos.nix
  ];

  programs.home-manager.enable = true;
}
