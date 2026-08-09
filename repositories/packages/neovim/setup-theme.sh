#!/bin/bash
set -eu

# @see [theme](https://github.com/catppuccin/nvim?tab=readme-ov-file#configuration)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

if [ $# -ne 2 ]; then
  log::error "Usage: $0 <flavour> <accent>"
  exit 2
fi

flavour="$1"

neovim_theme_file="${HOME}/.config/nvim/lua/plugins/catppuccin.lua"

if [ ! -f "${neovim_theme_file}" ]; then
  log::info "${neovim_theme_file} not found, skipping"
  exit 0
fi

file::replace_text \
  '^\([[:space:]]*\)flavour = ".*"' \
  "\1flavour = \"${flavour}\"" \
  "${neovim_theme_file}"

exit 0
