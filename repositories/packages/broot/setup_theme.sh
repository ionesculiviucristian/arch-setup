#!/bin/bash
set -eu

# [theme] https://github.com/catppuccin/broot?tab=readme-ov-file#usage

if [ $# -ne 2 ]; then
  echo "Usage: $0 <flavour> <accent>"
  exit 1
fi

flavour="$1"
accent="$2"

broot_dir="${HOME}/.config/broot"
broot_theme="catppuccin-${flavour}-${accent}"

mkdir -p "${broot_dir}/skins"

wget -qO \
  "${broot_dir}/skins/${broot_theme}.hjson" \
  "https://raw.githubusercontent.com/catppuccin/broot/refs/heads/main/themes/${flavour}/${broot_theme}.hjson"

sed -i \
  "s|file: skins/.*\.hjson|file: skins/${broot_theme}.hjson|" \
  "${broot_dir}/conf.hjson"

exit 0
