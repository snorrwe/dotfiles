{
  pkgs,
  username,
  host,
  inputs,
  ...
}:
{
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.05";

  imports = [
    ../../modules/hm/rice.nix
    ../../modules/hm/dunst.nix
    ../../modules/hm/picom.nix
    ../../modules/hm/git.nix
  ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.topgrade = {
    enable = true;
    package = pkgs.topgrade;
    settings = {
      misc = {
        assume_yes = true;
        cleanup = true;
        disable = [
          "system"
          "git_repos"
        ];
        pre_sudo = true;
      };
      commands = {
        "System flake" = "cd /home/${username}/.dotfiles && just update ${host}";
      };
    };

  };
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    theme = "Arc-Dark";
    font = "Monaspace Neon 12";
  };
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = builtins.readFile ../../.wezterm.lua;
    package = inputs.wezterm.packages.${pkgs.system}.default;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/mailto" = [ "userapp-Thunderbird-TWFWR2.desktop" ];
      "message/rfc822" = [ "userapp-Thunderbird-TWFWR2.desktop" ];
      "x-scheme-handler/mid" = [ "userapp-Thunderbird-TWFWR2.desktop" ];
      "x-scheme-handler/webcal" = [ "userapp-Thunderbird-HLSVR2.desktop" ];
      "text/calendar" = [ "userapp-Thunderbird-HLSVR2.desktop" ];
      "application/x-extension-ics" = [ "userapp-Thunderbird-HLSVR2.desktop" ];
      "x-scheme-handler/webcals" = [ "userapp-Thunderbird-HLSVR2.desktop" ];
      "x-scheme-handler/http" = [ "app.zen_browser.zen.desktop" ];
      "x-scheme-handler/https" = [ "app.zen_browser.zen.desktop" ];
      "x-scheme-handler/chrome" = [ "app.zen_browser.zen.desktop" ];
      "text/html" = [ "app.zen_browser.zen.desktop" ];
      "application/x-extension-htm" = [ "app.zen_browser.zen.desktop" ];
      "application/x-extension-html" = [ "app.zen_browser.zen.desktop" ];
      "application/x-extension-shtml" = [ "app.zen_browser.zen.desktop" ];
      "application/xhtml+xml" = [ "app.zen_browser.zen.desktop" ];
      "application/x-extension-xhtml" = [ "app.zen_browser.zen.desktop" ];
      "application/x-extension-xht" = [ "app.zen_browser.zen.desktop" ];
      "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
      "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
      "image/x-exr" = [ "org.kde.okteta.desktop" ];
      "x-scheme-handler/about" = [ "app.zen_browser.zen.desktop" ];
      "x-scheme-handler/unknown" = [ "app.zen_browser.zen.desktop" ];
    };
  };
}
