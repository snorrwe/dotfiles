{
  pkgs,
  features,
  lib,
  ...
}:
let
  inherit (pkgs.lib.lists) optionals;
in
with pkgs;
[
  xfce.thunar

  geeqie
  okteta

  perf
  hotspot # perf GUI

  betterlockscreen

  # niri
  wl-clipboard
  xwayland-satellite
  swaylock

  # quickly fire up VMs
  quickemu
  distrobox

  cloudflared
]
++ optionals features.enableGamedev (
  with pkgs;
  [
    aseprite
  ]
)
