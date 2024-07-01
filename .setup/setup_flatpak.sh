#!/usr/bin/env bash

set -euxo pipefail

sudo pacman -S --noconfirm extra/flatpak extra/flatpak-xdg-utils

flatpak install --noninteractive us.zoom.Zoom com.slack.Slack \
    com.jgraph.drawio.desktop \
    org.cloudcompare.CloudCompare \
    org.geeqie.Geeqie \
    discord \
    com.bitwarden.desktop  \
    chrome \
    org.videolan.VLC \
    io.github.martinrotter.rssguard \
    brave \
    com.google.Chrome \
    blender \
    meshlab \
    geeqie \
    krita 

