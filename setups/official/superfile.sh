#!/bin/bash
set -eu

superfile_dir="${HOME}/.config/superfile"

mkdir -p "${superfile_dir}/theme"

cp \
  "./configs/.config/superfile/config.toml" \
  "${superfile_dir}/config.toml"

wget -qO \
  "${superfile_dir}/theme/catppuccin-mocha-mauve.toml" \
  https://raw.githubusercontent.com/catppuccin/superfile/refs/heads/main/themes/mocha/catppuccin-mocha-mauve.toml

exit 0
