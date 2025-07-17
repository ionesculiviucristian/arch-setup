#!/bin/bash
set -eu

vim_themes_dir="${HOME}/.vim/colors"

mkdir -p "${vim_themes_dir}"

cp \
  "./configs/.vimrc" \
  "${HOME}/.vimrc"

wget -qO \
  "${vim_themes_dir}/catppuccin_mocha.vim" \
  https://raw.githubusercontent.com/catppuccin/vim/refs/heads/main/colors/catppuccin_mocha.vim

exit 0
