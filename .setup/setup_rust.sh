#!/usr/bin/env bash

set -ex

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

rustup component add rust-analyzer

# install rust fluff
cargo install -f cargo-binstall
cargo binstall -y cargo-nextest cargo-watch
