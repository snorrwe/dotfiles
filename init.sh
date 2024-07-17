#!/usr/bin/env bash

set -e

# FIXME: username
hostname=danilife

sudo nixos-generate-config --show-hardware-config > "./hosts/${hostname}/hardware.nix"
sudo nixos-rebuild switch --flake .
