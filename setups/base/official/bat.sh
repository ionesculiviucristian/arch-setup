#!/bin/bash
set -eu

# [Config] https://github.com/sharkdp/bat?tab=readme-ov-file#configuration-file
# [Theme] https://github.com/catppuccin/bat?tab=readme-ov-file#usage

# shellcheck source=../_config.sh
source "./setups/base/_config.sh"

# shellcheck source=../../../themes/base/official/bat.sh
source "./themes/base/official/bat.sh"

install_bat_theme

cp \
  "./configs/.config/bat/config" \
  "${bat_dir}/config"

exit 0
