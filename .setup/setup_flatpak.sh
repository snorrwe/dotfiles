#!/usr/bin/env bash

set -euxo pipefail

flatpak install --noninteractive us.zoom.Zoom com.slack.Slack \
    com.jgraph.drawio.desktop \
    org.cloudcompare.CloudCompare \
    org.geeqie.Geeqie \
    discord \
    com.bitwarden.desktop  \
    chrome \
    org.videolan.VLC \
    io.github.martinrotter.rssguard \
    com.google.Chrome \
    blender \
    meshlab \
    geeqie \
    md.obsidian.Obsidian \
    krita 

