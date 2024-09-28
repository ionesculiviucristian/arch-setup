#!/bin/bash
set -eu

# shellcheck disable=SC1091
source "./scripts/installer.sh"

sddm_conf_dir="/etc/sddm.conf.d"
sddm_theme="catppuccin-mocha-mauve-sddm"
sddm_themes_dir="/usr/share/sddm/themes"
wallpapers_dir="${HOME}/Pictures/Wallpapers"

sudo mkdir -p "${sddm_conf_dir}"

sudo pacman \
  -Syu \
  --needed \
  --noconfirm \
  qt6-svg \
  qt6-declarative \
  qt5-quickcontrols2 >/dev/null

sudo rm -rf "${sddm_themes_dir}/${sddm_theme}"

sudo mkdir -p "${sddm_themes_dir}/${sddm_theme}"

sudo_extract_from_url \
  https://github.com/catppuccin/sddm/releases/download/v1.1.1/${sddm_theme}.zip \
  "${sddm_themes_dir}/${sddm_theme}"

sudo_replace_text \
  '^CustomBackground="false"' \
  'CustomBackground="true"' \
  "${sddm_themes_dir}/${sddm_theme}/theme.conf"

sudo cp \
  "${wallpapers_dir}/wp11361931-minimalist-3440x1440-wallpapers.png" \
  "${sddm_themes_dir}/${sddm_theme}/backgrounds/wall.png"

sudo cp \
  "./configs/etc/sddm.conf.d/kde_settings.conf" \
  "${sddm_conf_dir}/kde_settings.conf"

exit 0
