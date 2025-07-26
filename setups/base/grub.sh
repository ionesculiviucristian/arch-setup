#!/bin/bash
set -eu

# https://www.gnu.org/software/grub/manual/grub/grub.html#Simple-configuration
# https://github.com/catppuccin/grub

catppuccin_grub_dir="${HOME}/.repos/catppuccin-grub"
grub_file="/etc/default/grub"
grub_themes_dir="/usr/share/grub/themes"

sudo sed -i 's/^GRUB_DEFAULT=0/GRUB_DEFAULT=saved/' "${grub_file}"
sudo sed -i 's/^#GRUB_SAVEDEFAULT=true/GRUB_SAVEDEFAULT=true/' "${grub_file}"
sudo sed -i 's/^#GRUB_DISABLE_SUBMENU=y/GRUB_DISABLE_SUBMENU=y/' "${grub_file}"

rm -rf "${catppuccin_grub_dir}"

git clone -q https://github.com/catppuccin/grub.git "${catppuccin_grub_dir}"

sudo cp -r \
  "${catppuccin_grub_dir}/src/catppuccin-mocha-grub-theme" \
  "${grub_themes_dir}/catppuccin-mocha-grub-theme"

sudo sed -i 's|^#GRUB_THEME="/path/to/gfxtheme"|GRUB_THEME="/usr/share/grub/themes/catppuccin-mocha-grub-theme/theme.txt"|' "${grub_file}"

sudo grub-mkconfig -o "/boot/grub/grub.cfg"

exit 0
