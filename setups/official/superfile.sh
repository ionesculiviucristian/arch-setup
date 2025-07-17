#!/bin/bash
set -eu

mkdir -p "${HOME}/.config/superfile"

cp "./configs/.config/superfile/config.toml" "${HOME}/.config/superfile/config.toml"

superfile_themes_dir="${HOME}/.config/superfile/theme"

mkdir -p "${superfile_themes_dir}"

wget -qO \
  "${superfile_themes_dir}/catppuccin-mocha-mauve.toml" \
  https://raw.githubusercontent.com/catppuccin/superfile/refs/heads/main/themes/mocha/catppuccin-mocha-mauve.toml

exit 0
