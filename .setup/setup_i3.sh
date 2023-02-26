#!/usr/bin/bash

set -ex

sudo pacman -Sq --noconfirm \
    i3-wm \
    polybar \
    picom \
    commnuniy/rofi
