#!/bin/bash
set -eu

# shellcheck source=../_config.sh
source "./setups/base/_config.sh"

kwriteconfig6 \
  --file "${kscreenlockerrc_file}" \
  --group "Greeter" \
  --group "Wallpaper" \
  --group "org.kde.image" \
  --group "General" \
  --key "Image" \
  "${wallpapers_dir}/wp11361979-minimalist-3440x1440-wallpapers.png"

kwriteconfig6 \
  --file "${kscreenlockerrc_file}" \
  --group "Greeter" \
  --group "Wallpaper" \
  --group "org.kde.image" \
  --group "General" \
  --key "PreviewImage" \
  "${wallpapers_dir}/wp11361979-minimalist-3440x1440-wallpapers.png"

exit 0
