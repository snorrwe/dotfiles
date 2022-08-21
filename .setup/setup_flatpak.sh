#!/usr/bin/bash

set -ex

flatpak install -y \
    com.bitwarden.desktop  \
    com.discordapp.Discord \
    com.slack.Slack \
    com.valvesoftware.Steam \
    md.obsidian.Obsidian
