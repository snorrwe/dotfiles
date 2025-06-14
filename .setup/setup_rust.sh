#!/usr/bin/env bash

set -ex

rustup default stable
rustup component add rust-analyzer

# install rust fluff
cargo install -f cargo-binstall
cargo binstall -y cargo-nextest cargo-watch cargo-clean-recursive
