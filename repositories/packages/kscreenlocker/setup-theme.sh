#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

if [ $# -ne 2 ]; then
  log::error "Usage: $0 <flavour> <accent>"
  exit 2
fi

wallpaper=$(theme::get '.wallpapers.greeter')

kscreenlockerrc_file="${HOME}/.config/kscreenlockerrc"
wallpapers_dir="${HOME}/Pictures/Wallpapers"

kwriteconfig6 \
  --file "${kscreenlockerrc_file}" \
  --group "Greeter" \
  --group "Wallpaper" \
  --group "org.kde.image" \
  --group "General" \
  --key "Image" \
  "${wallpapers_dir}/${wallpaper}"

kwriteconfig6 \
  --file "${kscreenlockerrc_file}" \
  --group "Greeter" \
  --group "Wallpaper" \
  --group "org.kde.image" \
  --group "General" \
  --key "PreviewImage" \
  "${wallpapers_dir}/${wallpaper}"

exit 0
