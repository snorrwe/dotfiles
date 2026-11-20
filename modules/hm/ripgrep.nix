{
  flake.modules.homeManager.cli = { pkgs, ... }: {
    programs.ripgrep = {
      enable = true;
    };
  };
}
