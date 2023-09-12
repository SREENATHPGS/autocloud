#!/bin/bash

sudo apt update
sudo apt install -yy wget zip unzip vim tree htop awscli
wget -O - https://raw.githubusercontent.com/SREENATHPGS/autocloud/main/install_scripts/install_docker.sh | bash
