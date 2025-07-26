#!/bin/bash
set -eu

# https://github.com/aristocratos/btop?tab=readme-ov-file#configurability
# https://github.com/catppuccin/btop

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

btop_dir="${HOME}/.config/btop"

_mkdir "${btop_dir}/themes"

download \
  "${btop_dir}/themes/catppuccin_mocha.theme" \
  https://raw.githubusercontent.com/catppuccin/btop/refs/heads/main/themes/catppuccin_mocha.theme

_cp \
  "./configs/.config/btop/btop.conf" \
  "${btop_dir}/btop.conf"

exit 0
