#!/bin/bash
set -eu

# shellcheck source=../../../setups/base/_config.sh
source "./setups/base/_config.sh"

install_konsole_theme() {
  mkdir -p "${konsole_dir}"

  wget -qO \
    "${konsole_dir}/${konsole_theme}" \
    "https://raw.githubusercontent.com/catppuccin/konsole/refs/heads/main/themes/${konsole_theme}"
}
