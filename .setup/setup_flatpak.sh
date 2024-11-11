#!/usr/bin/env bash

set -euxo pipefail

flatpak install --noninteractive \
    org.videolan.VLC \
    krita \
    com.google.Chrome \
    io.github.ungoogled_software.ungoogled_chromium \
    org.cloudcompare.CloudCompare \
    us.zoom.Zoom
