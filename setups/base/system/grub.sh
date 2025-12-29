#!/bin/bash
set -eu

# [Config] https://www.gnu.org/software/grub/manual/grub/grub.html
# [Theme] https://github.com/catppuccin/grub

# shellcheck source=../_config.sh
source "./setups/base/_config.sh"

# shellcheck disable=SC1091
source "./scripts/installer.sh"

# shellcheck source=../../../themes/base/system/grub.sh
source "./themes/base/system/grub.sh"

install_grub_theme

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
sudo_replace_text \
  '^GRUB_CMDLINE_LINUX_DEFAULT=".*"$' \
  'GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1 loglevel=4"' \
  "${grub_file}"
sudo_replace_text \
  '^#GRUB_DISABLE_OS_PROBER=false' \
  'GRUB_DISABLE_OS_PROBER=false' \
  "${grub_file}"

sudo grub-mkconfig -o "/boot/grub/grub.cfg" >/dev/null

exit 0
