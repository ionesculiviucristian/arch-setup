#!/bin/bash
set -eu

# @see [theme](https://github.com/catppuccin/kitty?tab=readme-ov-file#usage)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

if [ $# -ne 2 ]; then
  log::error "Usage: $0 <flavour> <accent>"
  exit 2
fi

flavour="$1"

kitty_config_dir="${HOME}/.config/kitty"
kitty_theme="${flavour}"

mkdir -p "${kitty_config_dir}/themes"

request::download \
  "https://raw.githubusercontent.com/catppuccin/kitty/refs/heads/main/themes/${kitty_theme}.conf" \
  "${kitty_config_dir}/themes/${kitty_theme}.conf"

file::replace_text \
  '^#\? *include.*themes/.*' \
  "include ~/.config/kitty/themes/${kitty_theme}.conf" \
  "${kitty_config_dir}/kitty.conf"

exit 0
