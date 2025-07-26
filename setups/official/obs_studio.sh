#!/bin/bash
set -eu

# https://github.com/catppuccin/obs

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

catppuccin_obs_dir="${HOME}/.repos/catppuccin-obs"
obs_dir="${HOME}/.config/obs-studio"

_mkdir "${obs_dir}/themes"

_rmdir "${catppuccin_obs_dir}"

git_clone https://github.com/catppuccin/obs "${catppuccin_obs_dir}"

_cp \
  "${catppuccin_obs_dir}/themes"/*.* \
  "${obs_dir}/themes"

_cp \
  "./configs/.config/obs-studio/user.ini" \
  "${obs_dir}/user.ini"

exit 0
