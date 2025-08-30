#!/usr/bin/env bash

nix-shell -p stow -p just -p nh --run "just install $@"
