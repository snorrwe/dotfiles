#!/usr/bin/bash

set -ex

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install ctlptl tilt kind tmuxinator kubectl helm
