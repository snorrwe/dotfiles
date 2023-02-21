#!/usr/bin/bash

set -ex

sudo pacman -Sq --noconfirm \
    i3-gnome 

mkdir -p dev
cd dev
git clone https://github.com/greshake/i3status-rust
cd i3status-rust
cargo install --path . --locked
./install.sh
