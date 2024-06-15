#!/usr/bin/bash

set -x

pushd "$(dirname "$0")"
trap popd EXIT

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
        git-lfs \
        nnn
}

echo "start" > install.log

(
    set -e
    install_packages
    echo "base packages" >> install.log
)

# tmux setup
if [ ! -d "$HOME"/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME"/.tmux/plugins/tpm
fi

( bash ./setup_yay.sh && echo yay >> install.log )
( bash ./setup_nvim.sh  && echo nvim >> install.log )
( bash ./setup_rust.sh  && echo rust >> install.log )
( bash ./setup_font.sh  && echo font >> install.log )
( bash ./setup_docker.sh  && echo docker >> install.log )
( bash ./setup_i3.sh  && echo i3 >> install.log )
( bash ./setup_zsh.sh  && echo zsh >> install.log )
