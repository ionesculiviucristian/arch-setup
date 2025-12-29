#!/bin/bash
set -eu

# shellcheck source=../../../setups/base/_config.sh
source "./setups/base/_config.sh"

install_atuin_theme() {
  mkdir -p "${atuin_dir}/themes"

  wget -qO \
    "${atuin_dir}/themes/${atuin_theme}.toml" \
    "https://raw.githubusercontent.com/catppuccin/atuin/refs/heads/main/themes/mocha/${atuin_theme}.toml"
}
