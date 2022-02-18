#!/usr/bin/bash

# install rust

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y

. "$HOME/.cargo/env"

# install rust fluff
cargo install ripgrep zoxide alacritty

# install starship
sh -c "$(curl -fsSL https://starship.rs/install.sh)"
