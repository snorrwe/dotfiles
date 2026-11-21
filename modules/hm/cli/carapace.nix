{
  flake.modules.homeManager.cli =
    { config, ... }:
    {
      # nicer completions in the terminal
      programs.carapace = {
        enable = true;
        enableZshIntegration = true;
        enableNushellIntegration = true;
        environment.CARAPACE_MATCH = true;
      };
    };
}
