{
  flake.modules.homeManager.cli = { pkgs, ... }: {
    programs.fd = {
      enable = true;
    };
  };
}
