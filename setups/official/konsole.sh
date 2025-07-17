#!/bin/bash
set -eu

mkdir -p "${HOME}/.local/share/konsole"

cp "./configs/.local/share/konsole/Starship.profile" "${HOME}/.local/share/konsole"

kwriteconfig6 --file "${HOME}/.config/konsolerc" --group "Desktop Entry" --key "DefaultProfile" "Starship.profile"

konsole_dir="${HOME}/.local/share/konsole"

mkdir -p "${konsole_dir}"

wget -qO \
  "${konsole_dir}/catppuccin-mocha.colorscheme" \
  https://raw.githubusercontent.com/catppuccin/konsole/refs/heads/main/themes/catppuccin-mocha.colorscheme

exit 0
