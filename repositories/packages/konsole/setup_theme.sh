#!/bin/bash
set -eu

# [theme] https://github.com/catppuccin/konsole?tab=readme-ov-file#usage

if [ $# -ne 2 ]; then
  echo "Usage: $0 <flavour> <accent>"
  exit 1
fi

flavour="$1"
# accent="$2"

konsole_dir="${HOME}/.local/share/konsole"
konsole_theme="catppuccin-${flavour}.colorscheme"

mkdir -p "${konsole_dir}"

wget -qO \
  "${konsole_dir}/${konsole_theme}" \
  "https://raw.githubusercontent.com/catppuccin/konsole/refs/heads/main/themes/${konsole_theme}"

sed -i \
  "s/^ColorScheme=.*/ColorScheme=catppuccin-${flavour}/" \
  "${konsole_dir}/Starship.profile"

exit 0
