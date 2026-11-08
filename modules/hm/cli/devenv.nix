{
  flake.modules.homeManager.cli = _: {
    programs.devenv = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
