#!/bin/bash
set -eu

# [theme] https://github.com/catppuccin/btop?tab=readme-ov-file#usage

if [ $# -ne 2 ]; then
  echo "Usage: $0 <flavour> <accent>"
  exit 1
fi

flavour="$1"
# accent="$2"

btop_dir="${HOME}/.config/btop"
btop_theme="catppuccin_${flavour}"

mkdir -p "${btop_dir}/themes"

wget -qO \
  "${btop_dir}/themes/${btop_theme}.theme" \
  "https://raw.githubusercontent.com/catppuccin/btop/refs/heads/main/themes/${btop_theme}.theme"

sed -i \
  "s/^color_theme = .*/color_theme = \"${btop_theme}\"/" \
  "${btop_dir}/btop.conf"

exit 0
