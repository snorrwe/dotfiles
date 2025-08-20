{ pkgs, ... }:
with pkgs;
[
  xfce.thunar

  geeqie
  libreoffice
  okteta

  hotspot # perf GUI

  betterlockscreen

  # niri
  wl-clipboard
  xwayland-satellite
  swaylock

  # quickly fire up VMs
  quickemu
]
