#!/bin/bash
set -eu

# https://github.com/catppuccin/konsole

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

konsole_dir="${HOME}/.local/share/konsole"

_mkdir "${konsole_dir}"

download \
  "${konsole_dir}/catppuccin-mocha.colorscheme" \
  https://raw.githubusercontent.com/catppuccin/konsole/refs/heads/main/themes/catppuccin-mocha.colorscheme

_cp \
  "./configs/.local/share/konsole/Starship.profile" \
  "${konsole_dir}/Starship.profile"

kwriteconfig6 \
  --file "${HOME}/.config/konsolerc" \
  --group "Desktop Entry" \
  --key "DefaultProfile" \
  "Starship.profile"

exit 0
