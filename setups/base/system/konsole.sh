#!/bin/bash
set -eu

# [Theme] https://github.com/catppuccin/konsole

konsole_dir="${HOME}/.local/share/konsole"
konsole_profile="Starship.profile"
konsole_theme="catppuccin-mocha.colorscheme"

mkdir -p "${konsole_dir}"

wget -qO \
  "${konsole_dir}/${konsole_theme}" \
  https://raw.githubusercontent.com/catppuccin/konsole/refs/heads/main/themes/${konsole_theme}

cp \
  "./configs/.local/share/konsole/${konsole_profile}" \
  "${konsole_dir}/${konsole_profile}"

kwriteconfig6 \
  --file "${HOME}/.config/konsolerc" \
  --group "Desktop Entry" \
  --key "DefaultProfile" \
  "${konsole_profile}"

exit 0
