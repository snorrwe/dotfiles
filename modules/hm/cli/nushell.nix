{
  flake.modules.homeManager.cli =
    {
      pkgs,
      ...
    }:
    {
      programs.nushell = {
        enable = true;
        plugins = with pkgs; [
          nushellPlugins.formats
        ];
      };
    };
}
