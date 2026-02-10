#!/bin/bash
set -eu

if [ $# -ne 1 ]; then
  echo "Usage: $0 <wallpaper>"
  exit 1
fi

wallpaper="$1"

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

wallpapers_dir="${HOME}/Pictures/Wallpapers"

cp "${root_dir}/media/wallpapers/"* "${wallpapers_dir}"

plasma-apply-wallpaperimage \
  "${wallpapers_dir}/${wallpaper}" >/dev/null

exit 0
