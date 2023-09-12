#!/bin/bash

function basic_packages() {
  sudo apt update
  sudo apt install -yy wget zip unzip vim tree htop awscli
}

function install_docker() {
  wget -O - https://raw.githubusercontent.com/SREENATHPGS/autocloud/main/install_scripts/install_docker.sh | bash
}

function install_git() {
  sudo apt install git -yy
}

function webserver() {
  sudo apt install nginx -yy
  sudo apt install certbot python3-certbot-nginx -yy
}

function install_all() {
  basic_packages
  install_docker
  install_git
  install_webserver
}
