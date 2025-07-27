#!/bin/bash
set -eu

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

sddm_conf_dir="/etc/sddm.conf.d"
sddm_themes_dir="/usr/share/sddm/themes"
wallpapers_dir="${HOME}/Pictures/Wallpapers"

_mkdir_sudo "${sddm_conf_dir}"

sudo pacman \
  -Syu \
  --needed \
  --noconfirm \
  qt6-svg \
  qt6-declarative \
  qt5-quickcontrols2 2>&1 | tee -a "./install.log" >/dev/null

_rmdir_sudo "${sddm_themes_dir}/catppuccin-mocha-mauve-sddm"
_mkdir_sudo "${sddm_themes_dir}/catppuccin-mocha-mauve-sddm"

download_extract_sudo \
  https://github.com/catppuccin/sddm/releases/download/v1.1.1/catppuccin-mocha-mauve-sddm.zip \
  "${sddm_themes_dir}/catppuccin-mocha-mauve-sddm"

sudo sed -i \
  -e 's/^CustomBackground="false"/CustomBackground="true"/' \
  "${sddm_themes_dir}/catppuccin-mocha-mauve-sddm/theme.conf"

_cp_sudo \
  "${wallpapers_dir}/wp11361931-minimalist-3440x1440-wallpapers.png" \
  "${sddm_themes_dir}/catppuccin-mocha-mauve-sddm/backgrounds/wall.png"

_cp_sudo \
  "./configs/etc/sddm.conf.d/kde_settings.conf" \
  "${sddm_conf_dir}/kde_settings.conf"

exit 0
