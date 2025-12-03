#!/bin/bash
set -eu

# [Config] https://sw.kovidgoyal.net/kitty/conf/#kitty-conf
# [Theme] https://github.com/catppuccin/kitty

kdeglobals_file="${HOME}/.config/kdeglobals"
kitty_dir="${HOME}/.config/kitty"
kitty_theme="mocha"

mkdir -p "${kitty_dir}/themes"

wget -qO \
  "${kitty_dir}/themes/${kitty_theme}.conf" \
  https://raw.githubusercontent.com/catppuccin/kitty/refs/heads/main/themes/${kitty_theme}.conf

cp \
  "./configs/.config/kitty/kitty.conf" \
  "${kitty_dir}/kitty.conf"

kwriteconfig6 \
  --file "${kdeglobals_file}" \
  --group "General" \
  --key "TerminalApplication" \
  "kitty"

kwriteconfig6 \
  --file "${kdeglobals_file}" \
  --group "General" \
  --key "TerminalService" \
  "kitty.desktop"

./scripts/update_bashrc.sh "kitty" << 'EOF'
# https://sw.kovidgoyal.net/kitty/kittens/ssh/
[ "${TERM}" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"
EOF

exit 0
