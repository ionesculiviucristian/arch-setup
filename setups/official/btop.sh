#!/bin/bash
set -eu

mkdir -p "${HOME}/.config/btop"

cp "./configs/.config/btop/btop.conf" "${HOME}/.config/btop/btop.conf"

btop_themes_dir="${HOME}/.config/btop/themes"

mkdir -p "${btop_themes_dir}"

wget -qO \
  "${btop_themes_dir}/catppuccin_mocha.theme" \
  https://raw.githubusercontent.com/catppuccin/btop/refs/heads/main/themes/catppuccin_mocha.theme

exit 0
