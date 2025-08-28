#!/usr/bin/env bash

set -x

pushd "$(dirname "$0")"
trap popd EXIT

echo "start" > install.log

(
    set -euo pipefail
    hostname=$1
    nix-shell -p just -p nh --run "just install $hostname"
    echo "apply nix flake" >> install.log
) || exit 1

echo "done" >> install.log
