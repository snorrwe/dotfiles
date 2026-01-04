{ pkgs, ... }:
with pkgs;
[
  thunar

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
