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
        alacritty \
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
if [ ! -f ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

git clone https://github.com/catppuccin/alacritty.git ~/alacritty-catppuccin

( bash "$HOME"/.setup/setup_yay.sh )
( bash "$HOME"/.setup/setup_nvim.sh )
( bash "$HOME"/.setup/setup_rust.sh )
( bash "$HOME"/.setup/setup_font.sh )
( bash "$HOME"/.setup/setup_docker.sh )
( bash "$HOME"/.setup/setup_i3.sh )
( bash "$HOME"/.setup/setup_brew.sh )
( bash "$HOME"/.setup/setup_zsh.sh )
