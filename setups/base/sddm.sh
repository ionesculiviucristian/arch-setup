#!/bin/bash
set -eu

sddm_conf_dir="/etc/sddm.conf.d"
sddm_themes_dir="/usr/share/sddm/themes"
wallpapers_dir="${HOME}/Pictures/Wallpapers"

sudo mkdir -p "${sddm_conf_dir}"

sudo cp \
  "./configs/etc/sddm.conf.d/kde_settings.conf" \
  "${sddm_conf_dir}/kde_settings.conf"

sudo pacman -Syu --needed --noconfirm \
  qt6-svg \
  qt6-declarative \
  qt5-quickcontrols2

wget -qO- https://github.com/catppuccin/sddm/releases/download/v1.1.0/catppuccin-mocha.zip | sudo bsdtar -xvf- -C "${sddm_themes_dir}"

sudo sed -i \
  -e 's/^CustomBackground="false"/CustomBackground="true"/' \
  "${sddm_themes_dir}/catppuccin-mocha/theme.conf"

sudo cp \
  "${wallpapers_dir}/wp11361931-minimalist-3440x1440-wallpapers.png" \
  "${sddm_themes_dir}/catppuccin-mocha/backgrounds/wall.jpg"

exit 0
