#!/bin/bash
set -eu

# [theme] https://github.com/catppuccin/atuin?tab=readme-ov-file#usage

if [ $# -ne 2 ]; then
  echo "Usage: $0 <flavour> <accent>"
  exit 1
fi

flavour="$1"
accent="$2"

atuin_dir="${HOME}/.config/atuin"
atuin_theme="catppuccin-${flavour}-${accent}"

mkdir -p "${atuin_dir}/themes"

wget -qO \
  "${atuin_dir}/themes/${atuin_theme}.toml" \
  "https://raw.githubusercontent.com/catppuccin/atuin/refs/heads/main/themes/${flavour}/${atuin_theme}.toml"

sed -i \
  "/^\[theme\]$/,/^name = /{s/^name = .*/name = \"${atuin_theme}\"/}" \
  "${atuin_dir}/config.toml"

exit 0
