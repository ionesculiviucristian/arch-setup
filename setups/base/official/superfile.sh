#!/bin/bash
set -eu

# [Config] https://superfile.netlify.app/configure/superfile-config/
# [Theme] https://github.com/catppuccin/superfile

superfile_dir="${HOME}/.config/superfile"
superfile_theme="catppuccin-mocha-mauve"

mkdir -p "${superfile_dir}/theme"

wget -qO \
  "${superfile_dir}/theme/${superfile_theme}.toml" \
  https://raw.githubusercontent.com/catppuccin/superfile/refs/heads/main/themes/mocha/${superfile_theme}.toml

cp \
  "./configs/.config/superfile/config.toml" \
  "${superfile_dir}/config.toml"

exit 0
