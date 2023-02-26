#!/usr/bin/bash

set -ex


# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y

. "$HOME/.cargo/env"

rustup component add rust-analyzer

# install rust fluff
cargo install -f ripgrep zoxide fd-find bat cargo-nextest cargo-watch
