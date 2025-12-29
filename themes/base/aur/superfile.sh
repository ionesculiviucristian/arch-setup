#!/bin/bash
set -eu

# shellcheck source=../../../setups/base/_config.sh
source "./setups/base/_config.sh"

install_superfile_theme() {
  mkdir -p "${superfile_dir}/theme"

  wget -qO \
    "${superfile_dir}/theme/${superfile_theme}.toml" \
    "https://raw.githubusercontent.com/catppuccin/superfile/refs/heads/main/themes/mocha/${superfile_theme}.toml"
}
