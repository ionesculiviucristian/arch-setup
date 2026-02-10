#!/bin/bash
set -eu

# [theme] https://github.com/catppuccin/superfile?tab=readme-ov-file#usage

if [ $# -ne 2 ]; then
  echo "Usage: $0 <flavour> <accent>"
  exit 1
fi

flavour="$1"
accent="$2"

superfile_dir="${HOME}/.config/superfile"
superfile_theme="catppuccin-${flavour}-${accent}"

mkdir -p "${superfile_dir}/theme"

wget -qO \
  "${superfile_dir}/theme/${superfile_theme}.toml" \
  "https://raw.githubusercontent.com/catppuccin/superfile/refs/heads/main/themes/${flavour}/${superfile_theme}.toml"

sed -i \
  "s/^theme=.*/theme=\"${superfile_theme}\"/" \
  "${superfile_dir}/config.toml"

exit 0
