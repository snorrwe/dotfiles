{
  flake.modules.homeManager.cli = { pkgs, ... }: {
    home.packages = with pkgs; [
      just
      dust # nicer du alternative
      watchexec
      diffutils
      github-cli
      git-lfs
      tokei # count LOC
      dysk # show disk usage, nicer default format than df
      hyperfine # cli benchmarking tool
      units
      unzip
      zip
    ];
  };
}
