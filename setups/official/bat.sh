#!/bin/bash
set -eu

mkdir -p "${HOME}/.config/bat"

cp "./configs/.config/bat/config" "${HOME}/.config/bat/config"

bat_themes_dir="${HOME}/.config/bat/themes"

mkdir -p "${bat_themes_dir}"

wget -qO \
  "${bat_themes_dir}/Catppuccin Mocha.tmTheme" \
  https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme

bat cache --build

exit 0
