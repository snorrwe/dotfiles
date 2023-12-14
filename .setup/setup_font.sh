#!/usr/bin/bash

set -ex

mkdir -p "$HOME"/.local/share/fonts
cd "$HOME"/.local/share/fonts
curl -fLo "CaskaydiaCove.zip" \
    https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip
unzip CaskaydiaCove.zip
