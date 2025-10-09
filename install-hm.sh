#!/usr/bin/env bash

# prevent stow from symlinking the whole .config directory, I only want the subdirectories
mkdir -p ~/.config
touch ~/.config/.keep

nix-shell -p stow -p just -p nh --run "just apply-hm $@ && just setup-git-hooks"
