#!/bin/bash

set -euxo pipefail

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

if [[ -f  /usr/share/terminfo/w/wezterm ]]; then
    # if you're reinstalling then this file will exist and wezterm install will fail
    sudo rm /usr/share/terminfo/w/wezterm
fi

yay -Sq --noconfirm \
        nerd-fonts \
        extra/obsidian \
        extra/thunderbird \
        extra/telegram-desktop \
        aur/spotify \
        flameshot \
        wezterm-git \
        otf-monaspace \
        btop \
        dust \
        flatpak \
        xdg-desktop-portal-gtk \
        ttf-nerd-fonts-symbols-mono \
        jq

