#!/usr/bin/env bash

set -euxo pipefail

flatpak install --noninteractive \
    org.cloudcompare.CloudCompare \
    org.videolan.VLC \
    io.github.martinrotter.rssguard \
    com.google.Chrome \
    blender \
    meshlab \
    us.zoom.Zoom \
    krita 

