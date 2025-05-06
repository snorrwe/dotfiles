{
  pkgs,
  username,
  host,
  inputs,
  ...
}:
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
        font = "Monaspace Neon 8";
      };
    };
  };
}
