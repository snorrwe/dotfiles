#!/usr/bin/env bash

set -euo pipefail

sudo echo 0 >/dev/null;
sudo nix-env --delete-generations --profile /nix/var/nix/profiles/system +2
sudo /run/current-system/bin/switch-to-configuration boot
nix-collect-garbage -d
