#!/usr/bin/bash

set -ex

# install some base tools
sudo apt install curl tmux build-essential cmake clang llvm clangd ninja-build -y

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y

. "$HOME/.cargo/env"

# install rust fluff
cargo install ripgrep zoxide alacritty fd-find

# install starship
sh -c "$(curl -fsSL https://starship.rs/install.sh)"

# install brew
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/bin/nvim
# clone nvim config
git clone https://github.com/snorrwe/nvim-config $HOME/.config/nvim

#install stuff via brew
brew install fzf
$(brew --prefix)/opt/fzf/install
brew install lazygit
