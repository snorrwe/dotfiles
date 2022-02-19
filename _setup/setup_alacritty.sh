#!/usr/bin/bash

set -ex

# alacritty debian dependencies
sudo apt-get install -y libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev
# alacritty
git clone https://github.com/alacritty/alacritty
cd alacritty
cargo build --release
tic -xe alacritty,alacritty-direct extra/alacritty.info
# desktop stuff
sudo cp target/release/alacritty /usr/local/bin
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
cd -
rm -rf alacritty
