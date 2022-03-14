#!/usr/bin/bash

set -ex

sudo pacman -Sq --noconfirm docker

(
sudo groupadd docker
sudo usermod -aG docker $USER
) || echo "Failed groupadd"

sudo chmod 666 /var/run/docker.sock
sudo systemctl start docker
sudo systemctl enable docker
