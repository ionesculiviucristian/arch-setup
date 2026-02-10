#!/bin/bash
set -eu

# [theme] https://github.com/catppuccin/bat?tab=readme-ov-file#usage

if [ $# -ne 2 ]; then
  echo "Usage: $0 <flavour> <accent>"
  exit 1
fi

flavour="$1"
# accent="$2"

bat_dir="${HOME}/.config/bat"
bat_theme="Catppuccin ${flavour^}"

mkdir -p "${bat_dir}/themes"

wget -qO \
  "${bat_dir}/themes/${bat_theme// /%20}.tmTheme" \
  "https://github.com/catppuccin/bat/raw/main/themes/${bat_theme// /%20}.tmTheme"

bat cache --build >/dev/null

sed -i \
  "s/^--theme=.*/--theme=\"${bat_theme}\"/" \
  "${bat_dir}/config"

exit 0
