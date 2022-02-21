#!/usr/bin/bash

set -ex

mkdir -p $HOME/.local/share/fonts
cd $HOME/.local/share/fonts && curl -fLo "CaskaydiaCove Nerd Font Complete.otf" \
    https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/CascadiaCode/Regular/complete/Caskaydia%20Cove%20Regular%20Nerd%20Font%20Complete.otf?raw=true
