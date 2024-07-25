#!/usr/bin/bash

set -ex


rustup component add rust-analyzer

# install rust fluff
cargo install -f cargo-binstall
cargo binstall -y cargo-nextest cargo-watch
