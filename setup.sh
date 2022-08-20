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
        base-devel \
        tar \
        gzip \
        diffutils \
        github-cli \
        flatpak \
        zsh \
        kitty
}
(
    set -e
    install_apt_stuff
)

( bash .setup/setup_nvim.sh )

# install oh-my-zsh
( sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" )

( bash .setup/setup_python_stuff.sh )
( bash .setup/setup_rust.sh )

( bash .setup/setup_font.sh )
( bash .setup/setup_docker.sh )
( bash .setup/setup_llvm.sh )

mkdir -p dev
