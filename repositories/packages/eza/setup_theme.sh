#!/bin/bash
set -eu

# [theme] https://github.com/catppuccin/eza?tab=readme-ov-file#usage

if [ $# -ne 2 ]; then
  echo "Usage: $0 <flavour> <accent>"
  exit 1
fi

flavour="$1"
accent="$2"

eza_dir="${HOME}/.config/eza"
eza_theme="catppuccin-${flavour}-${accent}"

mkdir -p "${eza_dir}"

wget -qO \
  "${eza_dir}/theme.yml" \
  "https://raw.githubusercontent.com/catppuccin/eza/refs/heads/main/themes/${flavour}/${eza_theme}.yml"

exit 0
