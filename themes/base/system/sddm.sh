#!/bin/bash
set -eu

# shellcheck source=../../../setups/base/_config.sh
source "./setups/base/_config.sh"

# shellcheck disable=SC1091
source "./scripts/installer.sh"

install_sddm_theme() {
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
    "https://github.com/catppuccin/sddm/releases/download/v1.1.2/${sddm_theme}.zip" \
    | sudo bsdtar -xf- -C "${sddm_themes_dir}/${sddm_theme}" --strip-components=1

  sudo_replace_text \
    '^CustomBackground="false"' \
    'CustomBackground="true"' \
    "${sddm_themes_dir}/${sddm_theme}/theme.conf"

  sudo cp \
    "${wallpapers_dir}/wp11361931-minimalist-3440x1440-wallpapers.png" \
    "${sddm_themes_dir}/${sddm_theme}/backgrounds/wall.png"
}
