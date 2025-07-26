#!/bin/bash
set -eu

# https://superfile.netlify.app/configure/superfile-config/
# https://github.com/catppuccin/superfile

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

superfile_dir="${HOME}/.config/superfile"

_mkdir "${superfile_dir}/theme"

download \
  "${superfile_dir}/theme/catppuccin-mocha-mauve.toml" \
  https://raw.githubusercontent.com/catppuccin/superfile/refs/heads/main/themes/mocha/catppuccin-mocha-mauve.toml

_cp \
  "./configs/.config/superfile/config.toml" \
  "${superfile_dir}/config.toml"

exit 0
