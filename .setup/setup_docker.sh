#!/usr/bin/bash

set -euxo pipefail

sudo pacman -S --noconfirm docker docker-buildx docker-compose

sudo systemctl stop docker

home_data_dir=${HOME}/docker-data

if [ -d /var/lib/docker ]; then
    sudo mv /var/lib/docker "$home_data_dir"
else
    mkdir -p "$home_data_dir"
fi
sudo ln -s "$home_data_dir" /var/lib/docker 

if [ ! "$(getent group docker)" ]; then
    sudo groupadd docker
fi

sudo usermod -aG docker "$USER"

sudo systemctl enable docker
sudo systemctl start docker
sudo chmod 666 /var/run/docker.sock
