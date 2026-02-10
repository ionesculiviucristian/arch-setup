#!/bin/bash
set -eu

# [theme] https://github.com/catppuccin/obs?tab=readme-ov-file#usage

if [ $# -ne 2 ]; then
  echo "Usage: $0 <flavour> <accent>"
  exit 1
fi

flavour="$1"
# accent="$2"

catppuccin_obs_dir="${HOME}/.repos/catppuccin-obs"
obs_dir="${HOME}/.config/obs-studio"

mkdir -p "${obs_dir}/themes"

rm -rf "${catppuccin_obs_dir}"

git clone -q --depth=1 https://github.com/catppuccin/obs \
  "${catppuccin_obs_dir}"

cp \
  "${catppuccin_obs_dir}/themes"/*.* \
  "${obs_dir}/themes"

sed -i \
  "s/^Theme=.*/Theme=com.obsproject.Catppuccin.${flavour^}/" \
  "${obs_dir}/user.ini"

exit 0
