#!/usr/bin/bash

set -ex

sudo apt install -y docker.io

sudo groupadd docker
sudo usermod -aG docker $USER

sudo systemctl start docker
