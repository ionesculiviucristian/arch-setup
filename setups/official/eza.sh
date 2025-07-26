#!/bin/bash
set -eu

# https://github.com/eza-community/eza?tab=readme-ov-file#custom-themes

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

eza_dir="${HOME}/.config/eza"

_mkdir "${eza_dir}"

download \
  "${eza_dir}/theme.yml" \
  https://raw.githubusercontent.com/eza-community/eza-themes/refs/heads/main/themes/catppuccin.yml 

exit 0
