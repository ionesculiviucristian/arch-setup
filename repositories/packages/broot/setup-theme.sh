#!/bin/bash
set -eu

# @see [theme](https://github.com/catppuccin/broot?tab=readme-ov-file#usage)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

if [ $# -ne 2 ]; then
  log::error "Usage: $0 <flavour> <accent>"
  exit 2
fi

flavour="$1"
accent="$2"

broot_config_dir="${HOME}/.config/broot"
broot_theme="catppuccin-${flavour}-${accent}"

mkdir -p "${broot_config_dir}/skins"

request::download \
  "https://raw.githubusercontent.com/catppuccin/broot/refs/heads/main/themes/${flavour}/${broot_theme}.hjson" \
  "${broot_config_dir}/skins/${broot_theme}.hjson"

file::replace_text \
  --range '/^ *dark$/,/^ *}/' \
  '^\( *\)file: skins/.*\.hjson' \
  "\1file: skins/${broot_theme}.hjson" \
  "${broot_config_dir}/conf.hjson"

exit 0
