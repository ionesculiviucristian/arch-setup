#!/bin/bash
set -eu

# shellcheck source=../../../setups/b450-i-aorus-pro-wifi/_config.sh
source "./setups/b450-i-aorus-pro-wifi/_config.sh"

install_obs_theme() {
  mkdir -p "${obs_dir}/themes"

  rm -rf "${catppuccin_obs_dir}"

  git clone -q https://github.com/catppuccin/obs "${catppuccin_obs_dir}"

  cp \
    "${catppuccin_obs_dir}/themes"/*.* \
    "${obs_dir}/themes"
}
