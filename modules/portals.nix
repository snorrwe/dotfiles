{ pkgs, ... }:
{
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      gnome-keyring
      xdg-desktop-portal-gtk
      xdg-desktop-portal
      xdg-desktop-portal-wlr
      xdg-desktop-portal-termfilechooser # Portal for using TUIs as file pickers
    ];
    config = {
      common = {
        default = "gtk";
        "org.freedesktop.impl.portal.ScreenCast" = "wlr"; # NOTE: This is required for screensharing to work properly
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
      };
    };
  };
}
