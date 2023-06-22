#!/usr/bin/bash

set -ex

# install oh-my-zsh
( sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" )
# install znap
git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git
source zsh-snap/znap.zsh
