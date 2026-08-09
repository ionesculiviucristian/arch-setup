#!/bin/bash
set -eu

# @see [theme](https://github.com/catppuccin/sddm?tab=readme-ov-file#usage)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

if [ $# -ne 2 ]; then
  log::error "Usage: $0 <flavour> <accent>"
  exit 2
fi

flavour="$1"
accent="$2"

wallpaper=$(theme::get '.wallpapers.sddm')

sddm_conf_dir="/etc/sddm.conf.d"
sddm_theme="catppuccin-${flavour}-${accent}-sddm"
sddm_cursors_theme="catppuccin-${flavour}-${accent}-cursors"
sddm_themes_dir="/usr/share/sddm/themes"
wallpapers_dir="${HOME}/Pictures/Wallpapers"

staging_dir=$(mktemp -d)
trap 'rm -rf "${staging_dir}"' EXIT

sudo pacman \
  -S \
  --needed \
  --noconfirm \
  qt6-svg \
  qt6-declarative \
  qt5-quickcontrols2 >/dev/null

request::extract \
  "https://github.com/catppuccin/sddm/releases/latest/download/${sddm_theme}.zip" \
  "${staging_dir}"

sudo rm -rf "${sddm_themes_dir}/${sddm_theme}"

sudo cp -r \
  "${staging_dir}/"* \
  "${sddm_themes_dir}/${sddm_theme}"

file::replace_text --sudo \
  '^CustomBackground="false"' \
  'CustomBackground="true"' \
  "${sddm_themes_dir}/${sddm_theme}/theme.conf"

sudo install -D -m 644 \
  "${wallpapers_dir}/${wallpaper}" \
  "${sddm_themes_dir}/${sddm_theme}/backgrounds/wall.png"

file::replace_text --sudo \
  '^Current=.*' \
  "Current=${sddm_theme}" \
  "${sddm_conf_dir}/kde_settings.conf"

file::replace_text --sudo \
  '^CursorTheme=.*' \
  "CursorTheme=${sddm_cursors_theme}" \
  "${sddm_conf_dir}/kde_settings.conf"

exit 0
