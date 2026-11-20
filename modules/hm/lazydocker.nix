{
  flake.modules.homeManager.cli = { pkgs, ... }: {
    programs.lazydocker = {
      enable = true;
    };
  };
}
