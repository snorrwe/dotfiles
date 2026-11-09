{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    let
      theme = "Juno-mirage";
      theme_pkg = pkgs.juno-theme;
      cursor_package = pkgs.afterglow-cursors-recolored;
      cursor_name = "Afterglow-Recolored-Catppuccin-Macchiato";
    in
    {
      home = {
        packages = with pkgs; [
          # needed by gtk
          dconf
        ];

        pointerCursor = {
          enable = true;
          name = cursor_name;
          package = cursor_package;
          x11.enable = true;
          gtk.enable = true;
        };

        sessionVariables.GTK_THEME = theme;
      };
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };

      gtk = {
        enable = true;
        font.name = "MonaspiceNe Nerd Font";
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
        style = {
          name = "catppuccin-mocha-mauve";
          package = pkgs.catppuccin-qt5ct;
        };

      };
    };
}
