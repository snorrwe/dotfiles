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
  perf
  # quickly fire up VMs
  quickemu
]
++ optionals features.enableGui (
  with pkgs;
  [
    hotspot # perf GUI
    betterlockscreen
    thunar
    geeqie
    okteta
    # niri
    wl-clipboard
    xwayland-satellite
    swaylock
    cloudflared
    brightnessctl
  ]
)
++ optionals features.enableGamedev (
  with pkgs;
  [
    aseprite
    renderdoc
  ]
)
