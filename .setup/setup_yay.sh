#!/bin/bash

set -ex

if ! command -v yay &> /dev/null
then
    sudo pacman -Sq --noconfirm \
        git \
        base-devel

    cd "$(mktemp -d)"

    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
fi

yay -Sq --noconfirm \
        nerd-fonts \
        extra/obsidian \
        aur/slack-desktop \
        extra/discord \
        extra/thunderbird \
        extra/telegram-desktop \
        aur/spotify \
        flameshot \
        wezterm-git \
        otf-monaspace \
        btop \
        dust
