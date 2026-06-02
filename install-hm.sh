#!/usr/bin/env bash

nix-shell -p just -p nh --run "just hm-apply $@ && just setup-git-hooks"
