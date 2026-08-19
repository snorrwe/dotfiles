{
  lib,
  pkgs,
  features,
  ...
}:
{
  config = lib.mkIf features.enableGui {
    systemd.user.services.tailscale-systray = {
      Unit = {
        Description = "Run tailscale systray";
      };
      Service = {
        ExecStart = "${pkgs.tailscale}/bin/tailscale systray";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
