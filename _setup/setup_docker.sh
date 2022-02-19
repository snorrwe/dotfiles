#!/usr/bin/bash

set -ex

sudo apt install -y docker.io

(
sudo groupadd docker
sudo usermod -aG docker $USER
) || echo "Failed groupadd"

sudo chmod 666 /var/lib/docker.sock
sudo systemctl start docker
sudo systemctl enable docker
