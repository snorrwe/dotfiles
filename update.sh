#!/usr/bin/env bash

set -euo pipefail

nix flake update
git commit -am "System update $(printf '%(%Y-%m-%d)T\n' -1)"
./apply.sh
