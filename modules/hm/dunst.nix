{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      # notifications service
      services.dunst = {
        enable = true;
        iconTheme = {
          name = "rose-pine-moon";
          package = pkgs.rose-pine-icon-theme;
        };
        settings = {
          global = {
            font = "MonaspiceNe Nerd Font 10";
            monitor = 1;
          };
        };
      };
    };
}
