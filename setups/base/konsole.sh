#!/bin/bash
set -eu

konsole_dir="${HOME}/.local/share/konsole"

mkdir -p "${konsole_dir}"

kwriteconfig6 \
  --file "${HOME}/.config/konsolerc" \
  --group "Desktop Entry" \
  --key "DefaultProfile" "Starship.profile"

wget -qO \
  "${konsole_dir}/catppuccin-mocha.colorscheme" \
  https://raw.githubusercontent.com/catppuccin/konsole/refs/heads/main/themes/catppuccin-mocha.colorscheme

cp \
  "./configs/.local/share/konsole/Starship.profile" \
  "${konsole_dir}/Starship.profile"

exit 0
