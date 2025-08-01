#!/bin/bash
set -eu

# [Config] https://github.com/aristocratos/btop?tab=readme-ov-file#configurability
# [Theme] https://github.com/catppuccin/btop

btop_dir="${HOME}/.config/btop"
btop_theme="catppuccin_mocha"

mkdir -p "${btop_dir}/themes"

wget -qO \
  "${btop_dir}/themes/${btop_theme}.theme" \
  https://raw.githubusercontent.com/catppuccin/btop/refs/heads/main/themes/${btop_theme}.theme

cp \
  "./configs/.config/btop/btop.conf" \
  "${btop_dir}/btop.conf"

exit 0
