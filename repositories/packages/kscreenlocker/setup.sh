#!/bin/bash
set -eu

if [ $# -ne 1 ]; then
  echo "Usage: $0 <wallpaper>"
  exit 1
fi

wallpaper="$1"

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
