#!/bin/bash
set -eu

# https://superfile.netlify.app/configure/superfile-config/
# https://github.com/catppuccin/superfile

superfile_dir="${HOME}/.config/superfile"

mkdir -p "${superfile_dir}/theme"

wget -qO \
  "${superfile_dir}/theme/catppuccin-mocha-mauve.toml" \
  https://raw.githubusercontent.com/catppuccin/superfile/refs/heads/main/themes/mocha/catppuccin-mocha-mauve.toml

cp \
  "./configs/.config/superfile/config.toml" \
  "${superfile_dir}/config.toml"

exit 0
