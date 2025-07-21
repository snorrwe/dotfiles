{ pkgs, ... }:
{
  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = [
          "gnome"
          "gtk"
        ];
      };
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      gnome-keyring
      xdg-desktop-portal-gnome
    ];
  };

}
