#!/bin/bash
set -eu

# @see [theme](https://github.com/catppuccin/konsole?tab=readme-ov-file#usage)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

if [ $# -ne 2 ]; then
  log::error "Usage: $0 <flavour> <accent>"
  exit 2
fi

flavour="$1"

konsole_dir="${HOME}/.local/share/konsole"
konsole_theme="catppuccin-${flavour}.colorscheme"

mkdir -p "${konsole_dir}"

request::download \
  "https://raw.githubusercontent.com/catppuccin/konsole/refs/heads/main/themes/${konsole_theme}" \
  "${konsole_dir}/${konsole_theme}"

file::replace_text \
  '^ColorScheme=.*' \
  "ColorScheme=catppuccin-${flavour}" \
  "${konsole_dir}/Starship.profile"

exit 0
