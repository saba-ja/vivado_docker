# packages required by vivado
#!/usr/bin/env bash
set -e
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo 'Install vivado required libraries'
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
apt-get install -y build-essential
apt-get install -y gcc
apt-get install -y libglib2.0-0
apt-get install -y libsm6
apt-get install -y libxi6
apt-get install -y libxrender1
apt-get install -y libxrandr2
apt-get install -y libfreetype6
apt-get install -y libfontconfig
apt-get install -y libxtst6
apt-get install -y openssl