#!/bin/bash
set -eu

bat_dir="${HOME}/.config/bat"

mkdir -p "${bat_dir}/themes"

cp \
  "./configs/.config/bat/config" \
  "${bat_dir}/config"

wget -qO \
  "${bat_dir}/themes/Catppuccin Mocha.tmTheme" \
  https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme

bat cache --build

exit 0
