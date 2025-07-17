{
  pkgs,
  lib,
  ...
}:
{
  services.betterlockscreen = {
    enable = true;
    package = pkgs.betterlockscreen;
    inactiveInterval = 10;
    arguments = [
      "-u"
      (builtins.toString ../../wallpaper.jpg)
      "--blur"
      "0.8"
    ];
  };
  home.activation.setupLockscreen = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.betterlockscreen}/bin/betterlockscreen -u ${../../wallpaper.jpg} --blur 0.8
  '';
}
