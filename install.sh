#!/usr/bin/env bash

nix-shell -p just -p nh --run "just hostname=$1 install"
