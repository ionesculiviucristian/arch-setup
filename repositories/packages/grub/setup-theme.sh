#!/bin/bash
set -eu

# @see [theme](https://github.com/catppuccin/grub?tab=readme-ov-file#usage)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

if [ $# -ne 2 ]; then
  log::error "Usage: $0 <flavour> <accent>"
  exit 2
fi

flavour="$1"

grub_file="/etc/default/grub"
catppuccin_grub_dir="${HOME}/.cache/arch-setup/catppuccin-grub"
grub_theme="catppuccin-${flavour}-grub-theme"
grub_themes_dir="/usr/share/grub/themes"

rm -rf "${catppuccin_grub_dir}"

git clone -q --depth=1 \
  https://github.com/catppuccin/grub.git \
  "${catppuccin_grub_dir}"

sudo rm -rf "${grub_themes_dir}/${grub_theme}"

sudo cp -r \
  "${catppuccin_grub_dir}/src/${grub_theme}" \
  "${grub_themes_dir}/${grub_theme}"

file::replace_text --sudo \
  '^#\?GRUB_THEME=.*' \
  "GRUB_THEME=\"${grub_themes_dir}/${grub_theme}/theme.txt\"" \
  "${grub_file}"

exit 0
