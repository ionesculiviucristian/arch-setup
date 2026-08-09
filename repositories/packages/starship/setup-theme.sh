#!/bin/bash
set -eu

# @see [config](https://starship.rs/config/)
# @see [theme](https://github.com/catppuccin/starship?tab=readme-ov-file#usage)

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

starship_config_file="${HOME}/.config/starship.toml"

theme_file=$(mktemp)
trap 'rm -f "${theme_file}"' EXIT

request::download \
  "https://raw.githubusercontent.com/catppuccin/starship/refs/heads/main/themes/${flavour}.toml" \
  "${theme_file}"

install -D -m 644 \
  "${package_dir}/config/config.toml" \
  "${starship_config_file}"

file::replace_text \
  '^#\? *palette = .*' \
  "palette = \"catppuccin_${flavour}\"" \
  "${starship_config_file}"

file::replace_text \
  --range '/^\[git_branch\]$/,/^style = /' \
  '^style = .*' \
  "style = \"bold ${accent}\"" \
  "${starship_config_file}"

cat "${theme_file}" >>"${starship_config_file}"

exit 0
