#!/usr/bin/env bash

set -euo pipefail

sudo echo 0 >/dev/null;
nix-collect-garbage -d
sudo nix-env --delete-generations +2
sudo /run/current-system/bin/switch-to-configuration boot
