#!/bin/bash
set -eu

# @see [theme](https://github.com/catppuccin/atuin?tab=readme-ov-file#usage)

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

atuin_config_dir="${HOME}/.config/atuin"
atuin_theme="catppuccin-${flavour}-${accent}"

mkdir -p "${atuin_config_dir}/themes"

request::download \
  "https://raw.githubusercontent.com/catppuccin/atuin/refs/heads/main/themes/${flavour}/${atuin_theme}.toml" \
  "${atuin_config_dir}/themes/${atuin_theme}.toml"

file::replace_text \
  --range '/^\[theme\]$/,/^name = /' \
  '^name = .*' \
  "name = \"${atuin_theme}\"" \
  "${atuin_config_dir}/config.toml"

exit 0
