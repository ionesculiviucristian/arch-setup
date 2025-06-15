#!/bin/bash
set -eu

# https://wiki.archlinux.org/title/Official_repositories#Enabling_multilib
sudo sed -i '/\[multilib\]/,/Include =/ s/^#//' "/etc/pacman.conf"

# https://wiki.archlinux.org/title/NVIDIA
sudo pacman -Syu --noconfirm \
  amd-ucode \
  dkms \
  lib32-nvidia-utils \
  linux-headers \
  linux-lts-headers \
  nvidia-container-toolkit \
  nvidia-open-dkms \
  nvidia-settings \
  nvidia-utils

# https://www.xp-pen.com/download/deco-03.html
wget https://download01.xp-pen.com/file/2024/06/XPPenLinux3.4.9-240607.tar.gz
tar -xzf "XPPenLinux3.4.9-240607.tar.gz"
sudo sh "./XPPenLinux3.4.9-240607/install.sh"
rm -rf XPPenLinux*

sudo mv "/etc/xdg/autostart/xppentablet.desktop" "/etc/xdg/autostart/xppentablet.desktop.bak"
