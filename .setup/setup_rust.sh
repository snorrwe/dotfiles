#!/usr/bin/bash

set -ex


# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y

. "$HOME/.cargo/env"

# install rust-analyzer
mkdir -p ~/.local/bin
curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
chmod +x ~/.local/bin/rust-analyzer

cargo install -f sccache --no-default-features
export RUSTC_WRAPPER=$HOME/.cargo/bin/sccache
# install rust fluff
cargo install -f ripgrep zoxide fd-find
