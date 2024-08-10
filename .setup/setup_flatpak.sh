#!/usr/bin/env bash

set -euxo pipefail

flatpak install --noninteractive us.zoom.Zoom \
    org.cloudcompare.CloudCompare \
    org.videolan.VLC \
    io.github.martinrotter.rssguard \
    com.google.Chrome \
    blender \
    meshlab \
    krita 


# Zoom uses this variable to detect what DE you're running and denies screen sharing in hyprland
# But seems to work perfectly fine if you unsed it
flatpak override --user --env XDG_SESSION_TYPE="" us.zoom.Zoom
