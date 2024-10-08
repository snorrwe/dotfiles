#!/usr/bin/env bash

set -euo pipefail

usage() {
    cat 1>&2 <<-EOF
USAGE: apply.sh HOSTNAME
If HOSTNAME is omitted, then the NIX_HOST environmental variable is used
EOF
    exit 1
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
                usage
        ;;
        *)
            hostname=$1
            shift
        ;;
    esac
done

if [[ -z "${hostname+x}" ]] && [[ -z "${NIX_HOST+x}" ]]; then
    usage
fi
hostname=${hostname:-$NIX_HOST}

mkdir -p "./hosts/${hostname}"
sudo nixos-generate-config --show-hardware-config > "./hosts/${hostname}/hardware.nix"
sudo nixos-rebuild switch --flake ".#${hostname}"
stow --adopt .
