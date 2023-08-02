#!/bin/bash
#

set -ex

sudo pacman -Sq --noconfirm \
    git \
    base-devel

cd $(mktemp -d)

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si


yay -Sq --noconfirm nerd-fonts alacritty-git
