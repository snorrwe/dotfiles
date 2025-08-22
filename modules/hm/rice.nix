{
  pkgs,
  username,
  host,
  inputs,
  ...
}:
let
  theme = "Nightfox-Teal-Dark";
  theme_pkg = pkgs.nightfox-gtk-theme.override {
    colorVariants = [
      "dark"
    ];
    themeVariants = [
      "teal"
    ];
  };
  cursor_package = pkgs.google-cursor;
  cursor_name = "GoogleDot-Black";
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
    enable = true;
    name = cursor_name;
    package = cursor_package;
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
      name = "rose-pine-moon";
      package = pkgs.rose-pine-icon-theme;
    };
    cursorTheme = {
      name = cursor_name;
      package = cursor_package;
    };

    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme = 1;
    '';

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

  };

  qt = {
    enable = true;
    platformTheme.name = theme;
    style.name = theme;
  };
}
