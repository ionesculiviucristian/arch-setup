#!/bin/bash
set -eu

# shellcheck source=../../../setups/base/_config.sh
source "./setups/base/_config.sh"

install_broot_theme() {
  mkdir -p "${broot_dir}/skins"

  wget -qO \
    "${broot_dir}/skins/${broot_theme}.hjson" \
    "https://raw.githubusercontent.com/catppuccin/broot/refs/heads/main/themes/mocha/${broot_theme}.hjson"

  sed -i \
    "s|file: skins/dark-blue.hjson|file: skins/${broot_theme}.hjson|" \
    "${broot_dir}/conf.hjson"
}
