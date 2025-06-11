#!/usr/bin/env bash

set -ex

# install znap
if [ ! -d "$HOME/zsh-snap" ];
then
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git "$HOME/zsh-snap"
fi
zsh -c "source $HOME/zsh-snap/znap.zsh"
