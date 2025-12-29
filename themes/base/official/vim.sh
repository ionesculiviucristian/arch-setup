#!/bin/bash
set -eu

# shellcheck source=../../../setups/base/_config.sh
source "./setups/base/_config.sh"

install_vim_theme() {
  mkdir -p "${vim_themes_dir}"

  wget -qO \
    "${vim_themes_dir}/catppuccin_mocha.vim" \
    "https://raw.githubusercontent.com/catppuccin/vim/refs/heads/main/colors/catppuccin_mocha.vim"
}
