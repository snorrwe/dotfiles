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
  home.packages = with pkgs; [
    # needed by gtk
    dconf
  ];
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.pointerCursor = {
    package = pkgs.numix-cursor-theme;
    name = "Numix-Cursor";
    x11.enable = true;
    gtk.enable = true;
  };

  home.sessionVariables.GTK_THEME = theme;
  gtk = {
    enable = true;
    font.name = "Monaspace Neon";
    font.package = pkgs.monaspace;

    theme = {
      name = theme;
      package = theme_pkg;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme=1
    '';

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
