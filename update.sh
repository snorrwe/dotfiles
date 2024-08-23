#!/usr/bin/env bash

set -euo pipefail

nix flake update
git add flake.lock
git commit -m "System update $(printf '%(%Y-%m-%d)T\n' -1)"
./apply.sh
