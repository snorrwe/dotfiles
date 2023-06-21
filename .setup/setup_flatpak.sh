#!/usr/bin/bash

set -ex

flatpak install -y \
    com.bitwarden.desktop  \
    com.discordapp.Discord \
    com.slack.Slack \
    md.obsidian.Obsidian \
    org.mozilla.Thunderbird \ 
    com.spotify.Client
