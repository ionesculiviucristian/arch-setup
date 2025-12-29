#!/bin/bash
set -eu

# shellcheck source=../../../setups/base/_config.sh
source "./setups/base/_config.sh"

install_eza_theme() {
  mkdir -p "${eza_dir}"

  wget -qO \
    "${eza_dir}/theme.yml" \
    "https://raw.githubusercontent.com/eza-community/eza-themes/refs/heads/main/themes/catppuccin-mocha.yml"
}
