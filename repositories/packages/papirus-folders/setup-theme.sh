#!/bin/bash
set -eu

# @see [config](https://github.com/PapirusDevelopmentTeam/papirus-folders?tab=readme-ov-file#script-usage)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

if [ $# -ne 2 ]; then
  log::error "Usage: $0 <flavour> <accent>"
  exit 2
fi

icon_theme=$(theme::get '.icons.theme')
folder_color=$(theme::get '.icons.color')

papirus-folders -C "${folder_color}" --theme "${icon_theme}" >/dev/null

kwriteconfig6 \
  --file "${HOME}/.config/kdeglobals" \
  --group "Icons" \
  --key "Theme" \
  "${icon_theme}"

exit 0
