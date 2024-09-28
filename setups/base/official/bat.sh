#!/bin/bash
set -eu

# [Config] https://github.com/sharkdp/bat?tab=readme-ov-file#configuration-file
# [Theme] https://github.com/catppuccin/bat?tab=readme-ov-file#usage

bat_dir="${HOME}/.config/bat"

mkdir -p "${bat_dir}/themes"

wget -qO \
  "${bat_dir}/themes/Catppuccin Mocha.tmTheme" \
  https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme

cp \
  "./configs/.config/bat/config" \
  "${bat_dir}/config"

bat cache --build >/dev/null

exit 0
