#!/bin/bash
set -eu

mkdir -p "${HOME}/.config/kitty"

cp "./configs/.config/kitty/kitty.conf" "${HOME}/.config/kitty"

kwriteconfig6 --file "${HOME}/.config/kdeglobals" --group "General" --key "TerminalApplication" "kitty"
kwriteconfig6 --file "${HOME}/.config/kdeglobals" --group "General" --key "TerminalService" "kitty.desktop"

./scripts/update_bashrc.sh '[ "${TERM}" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"'

kitty_themes_dir="${HOME}/.repos/catppuccin-fzf"

mkdir -p "${kitty_themes_dir}"

wget -qO \
  "${kitty_themes_dir}/mocha.conf" \
  https://raw.githubusercontent.com/catppuccin/kitty/refs/heads/main/themes/mocha.conf

exit 0
