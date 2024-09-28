#!/bin/bash
set -eu

# [Theme] https://github.com/catppuccin/obs

catppuccin_obs_dir="${HOME}/.repos/catppuccin-obs"
obs_dir="${HOME}/.config/obs-studio"

mkdir -p "${obs_dir}/themes"

rm -rf "${catppuccin_obs_dir}"

git clone -q https://github.com/catppuccin/obs "${catppuccin_obs_dir}"

cp \
  "${catppuccin_obs_dir}/themes"/*.* \
  "${obs_dir}/themes"

cp \
  "./configs/.config/obs-studio/user.ini" \
  "${obs_dir}/user.ini"

exit 0
