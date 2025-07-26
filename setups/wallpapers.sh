#!/bin/bash
set -eu

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

wallpapers_dir="${HOME}/Pictures/Wallpapers"

_cp \
  "./media/wallpapers/"* \
  "${wallpapers_dir}"

plasma-apply-wallpaperimage "${wallpapers_dir}/wp14259050-cyberpunk-3440x1440-wallpapers.png" 2>&1 | tee -a "./install.log" >/dev/null

exit 0
