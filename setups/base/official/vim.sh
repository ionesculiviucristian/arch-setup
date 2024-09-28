#!/bin/bash
set -eu

# [Theme] https://github.com/catppuccin/vim

vim_themes_dir="${HOME}/.vim/colors"

mkdir -p "${vim_themes_dir}"

wget -qO \
  "${vim_themes_dir}/catppuccin_mocha.vim" \
  https://raw.githubusercontent.com/catppuccin/vim/refs/heads/main/colors/catppuccin_mocha.vim

cp "./configs/.vimrc" "${HOME}/.vimrc"

exit 0
