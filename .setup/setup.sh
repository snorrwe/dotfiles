#!/usr/bin/env bash

set -x

pushd "$(dirname "$0")"
trap popd EXIT

echo "start" > install.log

(
    set -eu
    hostname=$1
    nix-shell -p just --run "just install $hostname"
    echo "apply nix flake" >> install.log
) || exit 1

( bash ./setup_nvim.sh  && echo nvim >> install.log )
( bash ./setup_rust.sh  && echo rust >> install.log )
( bash ./setup_zsh.sh  && echo zsh >> install.log )
echo done >> install.log
