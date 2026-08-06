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
      ninja
      cmake
      gzip
      nodejs_22
      curl

      pkg-config
      sccache
      visidata
      killall

      sshfs
      python3
    ];
  };

  imports = [
    ./cli.nix
    ./scripts.nix
    ./symlinks.nix
    ./setup-git-repos.nix
    ./parallel.nix
  ];

  programs.home-manager.enable = true;
}
