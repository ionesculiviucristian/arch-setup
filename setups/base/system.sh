#!/bin/bash
set -eu

# https://wiki.archlinux.org/title/Official_repositories#Enabling_multilib
sudo sed -i '/\[multilib\]/,/Include =/ s/^#//' "/etc/pacman.conf"

cp "./configs/powerdevilrc" "${HOME}/.config/powerdevilrc"

cp "/etc/bash.bashrc" "${HOME}/.bashrc"

exit 0
