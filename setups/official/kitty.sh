#!/bin/bash
set -eu

kitty_dir="${HOME}/.config/kitty"

mkdir -p "${kitty_dir}/themes"

cp \
  "./configs/.config/kitty/kitty.conf" \
  "${kitty_dir}/kitty.conf"

kwriteconfig6 \
  --file "${HOME}/.config/kdeglobals" \
  --group "General" \
  --key "TerminalApplication" "kitty"

kwriteconfig6 \
  --file "${HOME}/.config/kdeglobals" \
  --group "General" \
  --key "TerminalService" "kitty.desktop"

./scripts/update_bashrc.sh '[ "${TERM}" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"'

wget -qO \
  "${kitty_dir}/themes/mocha.conf" \
  https://raw.githubusercontent.com/catppuccin/kitty/refs/heads/main/themes/mocha.conf

exit 0
