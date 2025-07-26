#!/bin/bash
set -eu

# https://github.com/catppuccin/vim

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

vim_themes_dir="${HOME}/.vim/colors"

_mkdir "${vim_themes_dir}"

download \
  "${vim_themes_dir}/catppuccin_mocha.vim" \
  https://raw.githubusercontent.com/catppuccin/vim/refs/heads/main/colors/catppuccin_mocha.vim

_cp \
  "./configs/.vimrc" \
  "${HOME}/.vimrc"

exit 0
