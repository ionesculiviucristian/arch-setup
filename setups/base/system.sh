#!/bin/bash
set -eu

# shellcheck disable=SC1091
source "./scripts/installer.sh"

# https://wiki.archlinux.org/title/Official_repositories#Enabling_multilib
sudo sed -i '/\[multilib\]/,/Include =/ s/^#//' "/etc/pacman.conf"

sudo_replace_text \
  '^#precedence ::ffff:0:0/96  100' \
  'precedence ::ffff:0:0/96  100' \
  "/etc/gai.conf"

cp "./configs/powerdevilrc" "${HOME}/.config/powerdevilrc"

cp "./configs/.xprofile" "${HOME}/.xprofile"

cp "/etc/bash.bashrc" "${HOME}/.bashrc"

exit 0
