#!/bin/bash
set -eu

# [Theme] https://github.com/catppuccin/obs

# shellcheck source=../_config.sh
source "./setups/b450-i-aorus-pro-wifi/_config.sh"

# shellcheck source=../../../themes/b450-i-aorus-pro-wifi/official/obs.sh
source "./themes/b450-i-aorus-pro-wifi/official/obs.sh"

install_obs_theme

cp \
  "./configs/.config/obs-studio/user.ini" \
  "${obs_dir}/user.ini"

exit 0
