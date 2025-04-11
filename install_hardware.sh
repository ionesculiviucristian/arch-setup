#!/bin/bash
set -eu

sudo -v

# https://wiki.archlinux.org/title/Official_repositories#Enabling_multilib
sudo sed -i '/\[multilib\]/,/Include =/ s/^#//' /etc/pacman.conf

sudo pacman -Syu

# ==========================================
# Install hardware / misc
# ==========================================

sudo pacman -S --noconfirm \
  amd-ucode \
  lib32-nvidia-utils \
  nvidia-container-toolkit \
  nvidia-open-dkms \
  nvidia-settings \
  nvidia-util

# https://www.xp-pen.com/download/deco-03.html
wget https://download01.xp-pen.com/file/2024/06/XPPenLinux3.4.9-240607.tar.gz
tar -xzf XPPenLinux3.4.9-240607.tar.gz
sudo sh ./XPPenLinux3.4.9-240607/install.sh
rm -rf XPPenLinux*

# ==========================================
# Setup NVIDIA Container Toolkit
# ==========================================

sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
