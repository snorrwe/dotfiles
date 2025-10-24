#!/usr/bin/env bash

nix-shell -p just -p nh --run "just apply-hm $@ && just setup-git-hooks"
