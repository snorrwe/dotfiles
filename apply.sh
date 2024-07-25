#!/usr/bin/env bash

set -euo pipefail

# FIXME: username
hostname=snorrwe

mkdir -p "./hosts/${hostname}"
sudo nixos-generate-config --show-hardware-config > "./hosts/${hostname}/hardware.nix"
sudo nixos-rebuild switch --flake ".#${hostname}"
stow --adopt .
