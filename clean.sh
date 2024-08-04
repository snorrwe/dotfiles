#!/usr/bin/env bash

set -euo pipefail

nix-collect-garbage -d
sudo nix-env --delete-generations --profile /nix/var/nix/profiles/system 1d
sudo /run/current-system/bin/switch-to-configuration boot
