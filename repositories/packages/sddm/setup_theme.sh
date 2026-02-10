#!/bin/bash
set -eu

# [theme] https://github.com/catppuccin/sddm?tab=readme-ov-file#usage

if [ $# -ne 3 ]; then
  echo "Usage: $0 <flavour> <accent> <wallpaper>"
  exit 1
fi

flavour="$1"
accent="$2"
wallpaper="$3"

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

# shellcheck source=../../../scripts/installer.sh
source "${root_dir}/scripts/installer.sh"

sddm_conf_dir="/etc/sddm.conf.d"
sddm_theme="catppuccin-${flavour}-${accent}-sddm"
sddm_cursors_theme="catppuccin-${flavour}-${accent}-cursors"
sddm_themes_dir="/usr/share/sddm/themes"
wallpapers_dir="${HOME}/Pictures/Wallpapers"

sudo pacman \
  -Syu \
  --needed \
  --noconfirm \
  qt6-svg \
  qt6-declarative \
  qt5-quickcontrols2 >/dev/null

sudo rm -rf "${sddm_themes_dir}/${sddm_theme}"

sudo mkdir -p "${sddm_themes_dir}/${sddm_theme}"

wget -qO- \
  "https://github.com/catppuccin/sddm/releases/download/v1.1.2/${sddm_theme}.zip" |
  sudo bsdtar -xf- -C "${sddm_themes_dir}/${sddm_theme}" --strip-components=1

sudo_replace_text \
  '^CustomBackground="false"' \
  'CustomBackground="true"' \
  "${sddm_themes_dir}/${sddm_theme}/theme.conf"

sudo cp \
  "${wallpapers_dir}/${wallpaper}" \
  "${sddm_themes_dir}/${sddm_theme}/backgrounds/wall.png"

sudo sed -i \
  "s/^Current=.*/Current=${sddm_theme}/" \
  "${sddm_conf_dir}/kde_settings.conf"

sudo sed -i \
  "s/^CursorTheme=.*/CursorTheme=${sddm_cursors_theme}/" \
  "${sddm_conf_dir}/kde_settings.conf"

exit 0
