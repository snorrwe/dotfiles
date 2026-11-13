{
  flake.modules.nixos.common =
    { pkgs, username, ... }:
    let
      defaultBrowser = "app.zen_browser.zen";
    in
    {
      system.stateVersion = "24.05";

      users.users.${username}.packages = with pkgs; [
        pavucontrol
        pamixer
        pulseaudio
      ];

      environment = {
        systemPackages = with pkgs; [
          neovim
          curl
          networkmanagerapplet
          xhost
        ];
        sessionVariables.DEFAULT_BROWSER = defaultBrowser;
        sessionVariables.NIXOS_OZONE_WL = "1";
        shellInit = ''
          if [ -n "$DISPLAY" ]; then
            ${pkgs.xhost}/bin/xhost +si:localuser:$USER >/dev/null 2>&1 || true
          fi
        '';
      };

      programs.npm.enable = true;

      xdg.mime = {
        enable = true;
        defaultApplications = {
          "text/html" = defaultBrowser;
          "x-scheme-handler/http" = defaultBrowser;
          "x-scheme-handler/https" = defaultBrowser;
          "x-scheme-handler/about" = defaultBrowser;
          "x-scheme-handler/unknown" = defaultBrowser;
        };
      };

      services = {
        earlyoom.enable = true;
        logind.settings.Login = {
          # certain elements in my life might press the button while I'm working :)
          HandlePowerKey = "ignore";
          HandlePowerKeyLongPress = "ignore";
          HandleRebootKey = "ignore";
          HandleRebootKeyLongPress = "ignore";
          HandleSuspendKey = "ignore";
          HandleSuspendKeyLongPress = "ignore";
        };
      };
    };
}
