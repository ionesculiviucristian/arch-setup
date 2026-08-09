#!/bin/bash
set -eu

# @see [theme](https://github.com/catppuccin/obs?tab=readme-ov-file#usage)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

if [ $# -ne 2 ]; then
  log::error "Usage: $0 <flavour> <accent>"
  exit 2
fi

flavour="$1"

catppuccin_obs_dir="${HOME}/.cache/arch-setup/catppuccin-obs"
obs_config_dir="${HOME}/.config/obs-studio"

rm -rf "${catppuccin_obs_dir}"

git clone -q --depth=1 https://github.com/catppuccin/obs \
  "${catppuccin_obs_dir}"

install -D -m 644 \
  --target-directory "${obs_config_dir}/themes" \
  "${catppuccin_obs_dir}/themes"/*.*

file::replace_text \
  '^Theme=.*' \
  "Theme=com.obsproject.Catppuccin.${flavour^}" \
  "${obs_config_dir}/user.ini"

exit 0
