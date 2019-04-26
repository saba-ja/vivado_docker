#!/usr/bin/env bash
### every exit != 0 fails the script
set -e
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "   Install LXDE   "
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~"

# avoid lxpolkit as it causes annoying error message window
apt-get install -y --no-install-recommends policykit-1-gnome

# LXDE
apt-get install -y --no-install-recommends lxde

# Additional tools. kmod and xz-utils for nvidia driver install support.
apt-get install -y --no-install-recommends dbus-x11 
apt-get install -y --no-install-recommends procps 
apt-get install -y --no-install-recommends psmisc 
apt-get install -y --no-install-recommends lxlauncher 
apt-get install -y --no-install-recommends lxtask 
apt-get install -y --no-install-recommends kmod 
apt-get install -y --no-install-recommends software-properties-common
apt-get install -y --no-install-recommends xvfb
apt-get install -y --no-install-recommends x11vnc
apt-get install -y --no-install-recommends xz-utils

# Language/locale settings
echo $LANG UTF-8 > /etc/locale.gen && \
    apt-get install -y locales && \
    update-locale --reset LANG=$LANG

# some utils to have proper menus, mime file types etc.
apt-get install -y --no-install-recommends xdg-utils 
apt-get install -y --no-install-recommends xdg-user-dirs
apt-get install -y --no-install-recommends menu-xdg mime-support 
apt-get install -y --no-install-recommends desktop-file-utils 


# GTK 2 and 3 settings for icons and style, wallpaper
echo '
gtk-theme-name="Raleigh"
gtk-icon-theme-name="nuoveXT2"
' > /etc/skel/.gtkrc-2.0

mkdir -p /etc/skel/.config/gtk-3.0 &&
echo '
[Settings]
gtk-theme-name="Raleigh"\
gtk-icon-theme-name="nuoveXT2"
' > /etc/skel/.config/gtk-3.0/settings.ini

mkdir -p /etc/skel/.config/pcmanfm/LXDE
echo '
[*]
wallpaper_mode=stretch
wallpaper_common=1
wallpaper=/usr/share/lxde/wallpapers/lxde_blue.jpg
' > /etc/skel/.config/pcmanfm/LXDE/desktop-items-0.conf

mkdir -p /etc/skel/.config/libfm
echo '
[config]
quick_exec=1
' > /etc/skel/.config/libfm/libfm.conf

mkdir -p /etc/skel/.config/openbox/
echo '<?xml version="1.0" encoding="UTF-8"?>
<theme>
  <name>Clearlooks</name>
</theme>
' > /etc/skel/.config/openbox/lxde-rc.xml

echo '#!/bin/bash
startlxde &' >> /usr/local/bin/startx && chmod +x /usr/local/bin/startx

# startscript to copy dotfiles from /etc/skel
# runs either CMD or image command from docker run
echo '#!/bin/bash
[ -n "$HOME" ] && 
[ ! -e "$HOME/.config" ] && 
cp /etc/skel/.bash_logout $HOME/ && 
cp -R /etc/skel/.config $HOME/ &&
cp /etc/skel/.gtkrc-2.0 $HOME/ &&
cp /etc/skel/.profile $HOME/
' > /usr/local/bin/copy_defaults && chmod +x /usr/local/bin/copy_defaults

exec /usr/local/bin/copy_defaults

# RUN rm /usr/bin/lxpolkit