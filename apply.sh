#!/usr/bin/env bash

set -euo pipefail

usage() {
    cat 1>&2 <<-EOF
USAGE: apply.sh HOSTNAME
EOF
    exit 1
}

if (( "$#" != "1" )); then
    usage
fi

hostname=$1

mkdir -p "./hosts/${hostname}"
sudo nixos-generate-config --show-hardware-config > "./hosts/${hostname}/hardware.nix"
sudo nixos-rebuild switch --flake ".#${hostname}"
stow --adopt .
