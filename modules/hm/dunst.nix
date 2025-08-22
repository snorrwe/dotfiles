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
    waylandDisplay = "wayland-1";
    settings = {
      global = {
        font = "Monaspace Neon 10";
        monitor = 1;
      };
    };
  };
}
