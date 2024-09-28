#!/bin/bash
set -eu

# [Config] https://www.gnu.org/software/grub/manual/grub/grub.html
# [Theme] https://github.com/catppuccin/grub

# shellcheck disable=SC1091
source "./scripts/installer.sh"

catppuccin_grub_dir="${HOME}/.repos/catppuccin-grub"
grub_file="/etc/default/grub"
grub_theme="catppuccin-mocha-grub-theme"
grub_themes_dir="/usr/share/grub/themes"

rm -rf "${catppuccin_grub_dir}"
sudo rm -rf "${grub_themes_dir}/${grub_theme}"

git clone -q \
  https://github.com/catppuccin/grub.git \
  "${catppuccin_grub_dir}"

sudo cp -r \
  "${catppuccin_grub_dir}/src/${grub_theme}" \
  "${grub_themes_dir}/${grub_theme}"

sudo_replace_text \
  '^GRUB_DEFAULT=0' \
  'GRUB_DEFAULT=saved' \
  "${grub_file}"
sudo_replace_text \
  '^#GRUB_SAVEDEFAULT=true' \
  'GRUB_SAVEDEFAULT=true' \
  "${grub_file}"
sudo_replace_text \
  '^#GRUB_DISABLE_SUBMENU=y' \
  'GRUB_DISABLE_SUBMENU=y' \
  "${grub_file}"
sudo_replace_text \
  '^#GRUB_THEME="/path/to/gfxtheme"' \
  "GRUB_THEME=\"${grub_themes_dir}/${grub_theme}/theme.txt\"" \
  "${grub_file}" \
  "|"

sudo grub-mkconfig -o "/boot/grub/grub.cfg" >/dev/null

exit 0
