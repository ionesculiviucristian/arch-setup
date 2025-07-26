#!/bin/bash
set -eu

# https://github.com/sharkdp/bat?tab=readme-ov-file#on-arch-linux
# https://github.com/sharkdp/bat?tab=readme-ov-file#configuration-file
# https://github.com/catppuccin/bat?tab=readme-ov-file#usage

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

bat_dir="${HOME}/.config/bat"

_mkdir "${bat_dir}/themes"

download \
  "${bat_dir}/themes/Catppuccin Mocha.tmTheme" \
  https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme

_cp \
  "./configs/.config/bat/config" \
  "${bat_dir}/config"

bat cache --build 2>&1 | tee -a "./install.log" >/dev/null

exit 0
