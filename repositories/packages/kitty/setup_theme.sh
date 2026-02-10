#!/bin/bash
set -eu

# [theme] https://github.com/catppuccin/kitty?tab=readme-ov-file#usage

if [ $# -ne 2 ]; then
  echo "Usage: $0 <flavour> <accent>"
  exit 1
fi

flavour="$1"
# accent="$2"

kitty_dir="${HOME}/.config/kitty"
kitty_theme="${flavour}"

mkdir -p "${kitty_dir}/themes"

wget -qO \
  "${kitty_dir}/themes/${kitty_theme}.conf" \
  "https://raw.githubusercontent.com/catppuccin/kitty/refs/heads/main/themes/${kitty_theme}.conf"

sed -i \
  "s|^#\? *include.*themes/.*|include ~/.config/kitty/themes/${kitty_theme}.conf|" \
  "${kitty_dir}/kitty.conf"

exit 0
