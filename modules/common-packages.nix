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
  distrobox
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
  ]
)
++ optionals features.enableGamedev (
  with pkgs;
  [
    aseprite
    renderdoc
  ]
)
