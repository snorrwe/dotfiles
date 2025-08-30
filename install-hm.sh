#!/usr/bin/env bash

nix-shell -p stow -p just -p nh --run "just apply-hm $@"
rm -rf .git/hooks
ln -s "$PWD/.githooks" ./.git/hooks
