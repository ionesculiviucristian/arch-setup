#!/bin/bash
set -eu

# shellcheck source=../../../setups/base/_config.sh
source "./setups/base/_config.sh"

install_btop_theme() {
  mkdir -p "${btop_dir}/themes"

  wget -qO \
    "${btop_dir}/themes/${btop_theme}.theme" \
    "https://raw.githubusercontent.com/catppuccin/btop/refs/heads/main/themes/${btop_theme}.theme"
}
