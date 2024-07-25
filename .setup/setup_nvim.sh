#!/usr/bin/env bash

set -ex

# clone nvim config
if [ -d "$HOME"/.config/nvim ];
then
    rm -rf "$HOME"/.config/nvim
fi
git clone https://github.com/snorrwe/nvim-config "$HOME"/.config/nvim
python3 -m venv "$HOME"/.config/nvim/python3
