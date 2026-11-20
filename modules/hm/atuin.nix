{
  flake.modules.homeManager.cli = { pkgs, ... }: {
    programs.atuin = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };
  };
}
