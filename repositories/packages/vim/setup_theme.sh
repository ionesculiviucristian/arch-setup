#!/bin/bash
set -eu

# [theme] https://github.com/catppuccin/vim?tab=readme-ov-file#usage

if [ $# -ne 2 ]; then
  echo "Usage: $0 <flavour> <accent>"
  exit 1
fi

flavour="$1"
# accent="$2"

vim_theme="catppuccin_${flavour}"
vim_themes_dir="${HOME}/.vim/colors"

mkdir -p "${vim_themes_dir}"

wget -qO \
  "${vim_themes_dir}/${vim_theme}.vim" \
  "https://raw.githubusercontent.com/catppuccin/vim/refs/heads/main/colors/${vim_theme}.vim"

sed -i \
  "s/^colorscheme .*/colorscheme ${vim_theme}/" \
  "${HOME}/.vimrc"

exit 0
