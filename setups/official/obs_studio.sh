#!/bin/bash
set -eu

cp "./configs/.config/obs-studio/user.ini" "${HOME}/.config/obs-studio/user.ini"

catppuccin_obs_dir="${HOME}/.repos/catppuccin-obs"
obs_themes_dir="${HOME}/.config/obs-studio/themes"

mkdir -p "${obs_themes_dir}"

rm -rf "${catppuccin_obs_dir}"

git clone -q https://github.com/catppuccin/obs "${catppuccin_obs_dir}"

cp "${catppuccin_obs_dir}/themes"/*.* "${obs_themes_dir}"

exit 0
