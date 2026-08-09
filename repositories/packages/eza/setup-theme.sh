#!/bin/bash
set -eu

# @see [theme](https://github.com/catppuccin/eza?tab=readme-ov-file#usage)

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

eza_config_dir="${HOME}/.config/eza"
eza_theme="catppuccin-${flavour}-${accent}"

mkdir -p "${eza_config_dir}"

request::download \
  "https://raw.githubusercontent.com/catppuccin/eza/refs/heads/main/themes/${flavour}/${eza_theme}.yml" \
  "${eza_config_dir}/theme.yml"

exit 0
