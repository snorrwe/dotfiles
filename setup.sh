#!/usr/bin/bash

set -ex

function install_apt_stuff {
    # install some base tools
    sudo pacman -Sq --noconfirm \
        curl \
        tmux \
        cmake \
        pkg-config \
        python3 \
        python-pip \
        python-pipx \
        base-devel \
        tar \
        gzip \
        zip \
        unzip \
        diffutils \
        github-cli \
        flatpak \
        zsh \
        firefox \
        fzf \
        xclip \
        npm \
        lazygit \
        thunar \
        gitui \
        llvm \
        direnv
}
(
    set -e
    install_apt_stuff
)

mkdir -p dev

( bash .setup/setup_yay.sh )
( bash .setup/setup_nvim.sh )
( bash .setup/setup_rust.sh )
( bash .setup/setup_font.sh )
( bash .setup/setup_docker.sh )
( bash .setup/setup_flatpak.sh )
( bash .setup/setup_i3.sh )
( bash .setup/setup_zsh.sh )

# tmux setup
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
