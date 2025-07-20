#!/bin/bash
set -eu

# https://github.com/aristocratos/btop?tab=readme-ov-file#configurability
# https://github.com/catppuccin/btop

btop_dir="${HOME}/.config/btop"

mkdir -p "${btop_dir}/themes"

wget -qO \
  "${btop_dir}/themes/catppuccin_mocha.theme" \
  https://raw.githubusercontent.com/catppuccin/btop/refs/heads/main/themes/catppuccin_mocha.theme

cp \
  "./configs/.config/btop/btop.conf" \
  "${btop_dir}/btop.conf"

exit 0
