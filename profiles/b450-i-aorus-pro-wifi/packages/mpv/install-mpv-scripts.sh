#!/bin/bash
set -eu

# @see [script](https://github.com/Ashyni/mpv-scripts)
# @see [script](https://github.com/po5/thumbfast)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/profiles/*}"

# shellcheck source=SCRIPTDIR/../../../../lib/index.sh
source "${root_dir}/lib/index.sh"

mpv_scripts_dir="${HOME}/.config/mpv/scripts"

mkdir -p "${mpv_scripts_dir}"

request::download \
  "https://raw.githubusercontent.com/Ashyni/mpv-scripts/master/dynamic-crop.lua" \
  "${mpv_scripts_dir}/dynamic-crop.lua"

request::download \
  "https://raw.githubusercontent.com/po5/thumbfast/master/thumbfast.lua" \
  "${mpv_scripts_dir}/thumbfast.lua"

exit 0
