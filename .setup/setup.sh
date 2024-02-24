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
        kitty \
        thunar \
        gitui \
        llvm \
        direnv
}
(
    set -e
    install_packages
)

mkdir -p dev

# tmux setup
if [ ! -d "$HOME"/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME"/.tmux/plugins/tpm
fi

( bash ./.setup/setup_yay.sh )
( bash ./.setup/setup_nvim.sh )
( bash ./.setup/setup_rust.sh )
( bash ./.setup/setup_font.sh )
( bash ./.setup/setup_docker.sh )
( bash ./.setup/setup_i3.sh )
( bash ./.setup/setup_brew.sh )
( bash ./.setup/setup_zsh.sh )
chsh zsh
