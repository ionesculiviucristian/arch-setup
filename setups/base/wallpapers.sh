#!/bin/bash
set -eu

wallpapers_dir="${HOME}/Pictures/Wallpapers"

cp "./media/wallpapers/"* "${wallpapers_dir}"

plasma-apply-wallpaperimage \
  "${wallpapers_dir}/wp14259050-cyberpunk-3440x1440-wallpapers.png" >/dev/null

exit 0
