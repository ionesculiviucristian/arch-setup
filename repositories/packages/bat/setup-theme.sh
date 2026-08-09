#!/bin/bash
set -eu

# @see [theme](https://github.com/catppuccin/bat?tab=readme-ov-file#usage)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

if [ $# -ne 2 ]; then
  log::error "Usage: $0 <flavour> <accent>"
  exit 2
fi

flavour="$1"

bat_config_dir="${HOME}/.config/bat"
bat_theme="Catppuccin ${flavour^}"

mkdir -p "${bat_config_dir}/themes"

request::download \
  "https://github.com/catppuccin/bat/raw/main/themes/${bat_theme// /%20}.tmTheme" \
  "${bat_config_dir}/themes/${bat_theme}.tmTheme"

bat cache --build >/dev/null

file::replace_text \
  '^--theme=.*' \
  "--theme=\"${bat_theme}\"" \
  "${bat_config_dir}/config"

exit 0
