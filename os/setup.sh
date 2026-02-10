#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

sudo sed -i '/\[multilib\]/,/Include =/ s/^#//' "/etc/pacman.conf"

cp "${root_dir}/system/config/powerdevilrc" "${HOME}/.config/powerdevilrc"

cp "${root_dir}/system/config/.xprofile" "${HOME}/.xprofile"

cp "/etc/bash.bashrc" "${HOME}/.bashrc"

"${root_dir}/os/scripts/setup_directories.sh"
"${root_dir}/os/scripts/install_fonts.sh"
"${root_dir}/os/scripts/setup_wallpapers.sh"
"${root_dir}/os/scripts/setup_night_color.sh"
"${root_dir}/os/scripts/setup_mounts.sh"

exit 0
