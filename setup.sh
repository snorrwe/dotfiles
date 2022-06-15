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
        topgrade \
        kitty
}
(
    set -e
    install_apt_stuff
)

( bash .setup/setup_nvim.sh )

function install_brew {
    curl -L get.rvm.io > rvm-install
    bash < ./rvm-install
    source ~/.bashrc
    rm ./rvm-install
    rvm install 2.6.8
    rvm use 2.6.8
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null
}
(
    set -e
    install_brew
)

# install starship
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y

# install stuff via brew
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
brew install fzf
$(brew --prefix)/opt/fzf/install --all
brew install lazygit kind ctlptl tilt openssl ninja vifm bat kubectl k9s

( bash .setup/setup_python_stuff.sh )
( bash .setup/setup_rust.sh )

( bash .setup/setup_font.sh )
( bash .setup/setup_docker.sh )
( bash .setup/setup_llvm.sh )

mkdir -p dev
