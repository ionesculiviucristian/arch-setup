#!/bin/bash
set -eu

# [theme] https://github.com/catppuccin/grub?tab=readme-ov-file#usage

if [ $# -ne 2 ]; then
  echo "Usage: $0 <flavour> <accent>"
  exit 1
fi

flavour="$1"
# accent="$2"

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

# shellcheck source=../../../scripts/installer.sh
source "${root_dir}/scripts/installer.sh"

grub_file="/etc/default/grub"
catppuccin_grub_dir="${HOME}/.repos/catppuccin-grub"
grub_theme="catppuccin-${flavour}-grub-theme"
grub_themes_dir="/usr/share/grub/themes"

rm -rf "${catppuccin_grub_dir}"
sudo rm -rf "${grub_themes_dir}/${grub_theme}"

git clone -q --depth=1 \
  https://github.com/catppuccin/grub.git \
  "${catppuccin_grub_dir}"

sudo cp -r \
  "${catppuccin_grub_dir}/src/${grub_theme}" \
  "${grub_themes_dir}/${grub_theme}"

sudo sed -i \
  "s|^#\?GRUB_THEME=.*|GRUB_THEME=\"${grub_themes_dir}/${grub_theme}/theme.txt\"|" \
  "${grub_file}"

sudo grub-mkconfig -o "/boot/grub/grub.cfg" >/dev/null

exit 0
