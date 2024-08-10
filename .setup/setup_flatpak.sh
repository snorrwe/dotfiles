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

