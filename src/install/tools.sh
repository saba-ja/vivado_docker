#!/usr/bin/env bash
### every exit != 0 fails the script
set -e
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Install some common tools for further installation"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
apt-get install -y software-properties-common
apt-get install -y vim
apt-get install -y wget
apt-get install -y net-tools
apt-get install -y locales
apt-get install -y bzip2
apt-get install -y curl
apt-get install -y supervisor
apt-get install -y sudo 

locale-gen en_US.UTF-8