#!/usr/bin/env bash

nix-shell -p just -p nh --run "just install $@"
rm -rf .git/hooks
ln -s $(pwd)/.githooks ./.git/hooks
