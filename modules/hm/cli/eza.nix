{
  flake.modules.homeManager.cli = { pkgs, ... }: {
    programs.eza = {
      enable = true;
      git = true;
    };
  };
}
