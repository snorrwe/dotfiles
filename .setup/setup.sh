#!/usr/bin/bash

set -ex

function install_packages {
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
        zsh \
        firefox \
        fzf \
        xclip \
        npm \
        lazygit \
        thunar \
        gitui \
        llvm \
        direnv \
        stow \
        clang \
        mold \
        git-lfs
}
(
    set -e
    install_packages
)

# tmux setup
if [ ! -d "$HOME"/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME"/.tmux/plugins/tpm
fi

( bash ./setup_yay.sh )
( bash ./setup_nvim.sh )
( bash ./setup_rust.sh )
( bash ./setup_font.sh )
( bash ./setup_docker.sh )
( bash ./setup_i3.sh )
( bash ./setup_zsh.sh )
