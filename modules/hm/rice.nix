{
  pkgs,
  username,
  host,
  inputs,
  ...
}:
let
  theme = "palenight";
  theme_pkg = pkgs.palenight-theme;
in
{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.sessionVariables.GTK_THEME = theme;
  gtk = {
    enable = true;

    theme = {
      name = theme;
      package = theme_pkg;
    };
    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

  };

  qt = {
    enable = true;
    platformTheme.name = theme;
    style.name = theme;
  };
}
