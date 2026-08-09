#!/bin/bash
set -eu

# @see [theme](https://github.com/catppuccin/btop?tab=readme-ov-file#usage)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

if [ $# -ne 2 ]; then
  log::error "Usage: $0 <flavour> <accent>"
  exit 2
fi

flavour="$1"

btop_config_dir="${HOME}/.config/btop"
btop_theme="catppuccin_${flavour}"

mkdir -p "${btop_config_dir}/themes"

request::download \
  "https://raw.githubusercontent.com/catppuccin/btop/refs/heads/main/themes/${btop_theme}.theme" \
  "${btop_config_dir}/themes/${btop_theme}.theme"

file::replace_text \
  '^color_theme = .*' \
  "color_theme = \"${btop_theme}\"" \
  "${btop_config_dir}/btop.conf"

exit 0
