#!/usr/bin/env bash

set -euxo pipefail

sudo pacman -S --noconfirm extra/flatpak extra/flatpak-xdg-utils

flatpak install --noninteractive us.zoom.Zoom com.spotify.Client com.slack.Slack
