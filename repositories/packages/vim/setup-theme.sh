#!/bin/bash
set -eu

# @see [theme](https://github.com/catppuccin/vim?tab=readme-ov-file#usage)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

if [ $# -ne 2 ]; then
  log::error "Usage: $0 <flavour> <accent>"
  exit 2
fi

flavour="$1"

vim_theme="catppuccin_${flavour}"
vim_themes_dir="${HOME}/.vim/colors"

mkdir -p "${vim_themes_dir}"

request::download \
  "https://raw.githubusercontent.com/catppuccin/vim/refs/heads/main/colors/${vim_theme}.vim" \
  "${vim_themes_dir}/${vim_theme}.vim"

file::replace_text \
  '^colorscheme .*' \
  "colorscheme ${vim_theme}" \
  "${HOME}/.vimrc"

exit 0
