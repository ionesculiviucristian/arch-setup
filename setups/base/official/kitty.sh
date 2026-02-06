#!/bin/bash
set -eu

# [Config] https://sw.kovidgoyal.net/kitty/conf/#kitty-conf
# [Theme] https://github.com/catppuccin/kitty

# shellcheck source=../_config.sh
source "./setups/base/_config.sh"

# shellcheck source=../../../themes/base/official/kitty.sh
source "./themes/base/official/kitty.sh"

install_kitty_theme

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

./scripts/update_bashrc.sh "kitty" <<'EOF'
# https://sw.kovidgoyal.net/kitty/kittens/ssh/
[ "${TERM}" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"
EOF

exit 0
