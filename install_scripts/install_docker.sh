#!/bin/bash

sudo apt-get update

sudo apt-get -yy install ca-certificates curl gnupg lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get -yy install docker-ce docker-ce-cli containerd.io

##Run the below commands manually to user docker without sudo
#groupadd docker
#usermod -aG docker $USER

echo "Docker Installation over. Run `docker run hello-world` to verify."
