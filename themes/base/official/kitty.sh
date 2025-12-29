#!/bin/bash
set -eu

# shellcheck source=../../../setups/base/_config.sh
source "./setups/base/_config.sh"

install_kitty_theme() {
  mkdir -p "${kitty_dir}/themes"

  wget -qO \
    "${kitty_dir}/themes/${kitty_theme}.conf" \
    "https://raw.githubusercontent.com/catppuccin/kitty/refs/heads/main/themes/${kitty_theme}.conf"
}
