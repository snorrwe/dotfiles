{ pkgs, ... }:
{
  systemd.user.services.snorrwe-swaybg = {
    enable = true;
    unitConfig = {
      Description = "Wallpaper";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session-pre.target" ];
    };

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i ${../wallpaper.jpg}";
      Restart = "on-failure";
      RestartSec = 1;
    };

    wantedBy = [ "graphical-session.target" ];
  };
}
