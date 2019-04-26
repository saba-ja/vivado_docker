#!/usr/bin/env bash
### every exit != 0 fails the script
set -e
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Install nss-wrapper to be able to execute image as non-root user"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
apt-get install -y libnss-wrapper gettext

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "add 'source generate_container_user' to .bashrc"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
# have to be added to hold all env vars correctly
echo 'source $STARTUPDIR/generate_container_user' >> $HOME/.bashrc