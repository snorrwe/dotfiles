#!/usr/bin/bash

set -ex

brew install docker

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker 
docker run hello-world
