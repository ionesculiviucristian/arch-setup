#!/bin/bash
set -eu

# [Theme] https://github.com/eza-community/eza?tab=readme-ov-file#custom-themes

eza_dir="${HOME}/.config/eza"

mkdir -p "${eza_dir}"

wget -qO \
  "${eza_dir}/theme.yml" \
  https://raw.githubusercontent.com/eza-community/eza-themes/refs/heads/main/themes/catppuccin.yml 

exit 0
