#!/usr/bin/bash

set -ex

mkdir -p "$HOME"/.local/share/fonts
cd "$HOME"/.local/share/fonts
curl -fLo "CaskaydiaCove.zip" \
    https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip

unzip CaskaydiaCove.zip

curl -fLo "intelone-mono.zip" \
    https://github.com/intel/intel-one-mono/releases/download/V1.2.1/ttf.zip

unzip intelone-mono.zip
mv ttf/* ./
rm -rf ttf
rm -f intelone-mono.zip

curl -fLo "ComicMono.ttf" \
    https://dtinth.github.io/comic-mono-font/ComicMono.ttf
curl -fLo "ComicMono-Bold.ttf" \
    https://dtinth.github.io/comic-mono-font/ComicMono-Bold.ttf

