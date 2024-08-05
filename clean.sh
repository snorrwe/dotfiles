#!/usr/bin/env bash

set -euo pipefail

nix-collect-garbage -d
sudo nix-env --delete-generations +2
sudo /run/current-system/bin/switch-to-configuration boot
