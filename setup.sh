#!/usr/bin/bash

set -ex

function install_apt_stuff {
    # install some base tools
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install -y \
        curl \
        tmux \
        build-essential \
        cmake \
        pkg-config \
        flatpak \
        fontconfig-config
}
(
    set -e
    install_apt_stuff
)
( bash _setup/setup_llvm.sh )

# install brew
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null

# install stuff via brew
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
brew install fzf
$(brew --prefix)/opt/fzf/install --all
brew install lazygit kind ctlptl tilt openssl ninja python vifm docker

( bash _setup/setup_python_stuff.sh )
( bash _setup/setup_rust.sh )

# install starship
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y

( bash _setup/setup_nvim.sh )
( bash _setup/setup_alacritty.sh )
( bash _setup/setup_font.sh )

mkdir -p dev
