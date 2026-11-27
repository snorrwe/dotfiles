{
  flake.modules.homeManager.cli = { pkgs, ... }: {
    programs.jq = {
      enable = true;
    };
  };
}
