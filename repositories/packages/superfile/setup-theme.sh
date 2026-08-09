#!/bin/bash
set -eu

# @see [theme](https://github.com/catppuccin/superfile?tab=readme-ov-file#usage)

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

superfile_config_dir="${HOME}/.config/superfile"
superfile_theme="catppuccin-${flavour}-${accent}"

mkdir -p "${superfile_config_dir}/theme"

request::download \
  "https://raw.githubusercontent.com/catppuccin/superfile/refs/heads/main/themes/${flavour}/${superfile_theme}.toml" \
  "${superfile_config_dir}/theme/${superfile_theme}.toml"

file::replace_text \
  '^theme = .*' \
  "theme = \"${superfile_theme}\"" \
  "${superfile_config_dir}/config.toml"

exit 0
