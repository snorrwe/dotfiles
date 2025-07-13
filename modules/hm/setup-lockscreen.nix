{ pkgs, lib, ... }:
{
  home.activation.setupLockscreen = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.betterlockscreen}/bin/betterlockscreen -u ~/wallpaper.jpg --blur 0.3
  '';
}
