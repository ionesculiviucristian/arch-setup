#!/bin/bash
set -eu

catppuccin_grub_dir="${HOME}/.repos/catppuccin-grub"
grub_themes_dir="/usr/share/grub/themes"

sudo sed -i 's/^GRUB_DEFAULT=0/GRUB_DEFAULT=saved/' "/etc/default/grub"
sudo sed -i 's/^#GRUB_SAVEDEFAULT=true/GRUB_SAVEDEFAULT=true/' "/etc/default/grub"
sudo sed -i 's/^#GRUB_DISABLE_SUBMENU=y/GRUB_DISABLE_SUBMENU=y/' "/etc/default/grub"

rm -rf "${catppuccin_grub_dir}"

git clone -q https://github.com/catppuccin/grub.git "${catppuccin_grub_dir}"

sudo cp -r "${catppuccin_grub_dir}/src/catppuccin-mocha-grub-theme" "${grub_themes_dir}/catppuccin-mocha-grub-theme"

if ! grep -q "catppuccin-mocha-grub-theme" "/boot/grub/grub.cfg"; then
  sudo sed -i 's|^#GRUB_THEME="/path/to/gfxtheme"|GRUB_THEME="/usr/share/grub/themes/catppuccin-mocha-grub-theme/theme.txt"|' "/etc/default/grub"
fi

sudo grub-mkconfig -o "/boot/grub/grub.cfg"

exit 0
