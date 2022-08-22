#!/usr/bin/bash

set -ex

# setup fuse
sudo pacman -S fuse2


curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/bin/nvim
# clone nvim config
if [ -d $HOME/.config/nvim ];
then
    rm -rf $HOME/.config/nvim
fi
git clone https://github.com/snorrwe/nvim-config $HOME/.config/nvim
python3 -m venv $HOME/.config/nvim/python3
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim \
 || echo Failed to setup packer. Proceeding
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

