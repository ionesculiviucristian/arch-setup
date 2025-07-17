#!/bin/bash
set -eu

btop_dir="${HOME}/.config/btop"

mkdir -p "${btop_dir}/themes"

cp \
  "./configs/.config/btop/btop.conf" \
  "${btop_dir}/btop.conf"

wget -qO \
  "${btop_dir}/themes/catppuccin_mocha.theme" \
  https://raw.githubusercontent.com/catppuccin/btop/refs/heads/main/themes/catppuccin_mocha.theme

exit 0
