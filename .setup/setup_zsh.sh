#!/usr/bin/env bash

set -ex

# install znap
git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git "$HOME"/zsh-snap
zsh -c "source $HOME/zsh-snap/znap.zsh"
