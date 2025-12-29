#!/bin/bash
set -eu

# shellcheck source=../../../setups/base/_config.sh
source "./setups/base/_config.sh"

install_bat_theme() {
  mkdir -p "${bat_dir}/themes"

  wget -qO \
    "${bat_dir}/themes/Catppuccin Mocha.tmTheme" \
    "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme"

  bat cache --build >/dev/null
}
