#!/usr/bin/env bash
### every exit != 0 fails the script
set -e
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "  Installing custom fonts  "
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
apt-get install -y ttf-wqy-zenhei
apt-get install -y ttf-ubuntu-font-family

