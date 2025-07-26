#!/bin/bash
set -eu

# https://sw.kovidgoyal.net/kitty/conf/#kitty-conf
# https://github.com/catppuccin/kitty

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

kitty_dir="${HOME}/.config/kitty"

_mkdir "${kitty_dir}/themes"

download \
  "${kitty_dir}/themes/mocha.conf" \
  https://raw.githubusercontent.com/catppuccin/kitty/refs/heads/main/themes/mocha.conf

_cp \
  "./configs/.config/kitty/kitty.conf" \
  "${kitty_dir}/kitty.conf"

kwriteconfig6 \
  --file "${HOME}/.config/kdeglobals" \
  --group "General" \
  --key "TerminalApplication" \
  "kitty"

kwriteconfig6 \
  --file "${HOME}/.config/kdeglobals" \
  --group "General" \
  --key "TerminalService" \
  "kitty.desktop"

./scripts/update_bashrc.sh '[ "${TERM}" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"'

exit 0
