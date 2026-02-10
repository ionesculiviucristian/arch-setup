#!/bin/bash
set -eu

# [config] https://sw.kovidgoyal.net/kitty/conf/#kitty-conf

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

kitty_dir="${HOME}/.config/kitty"
kdeglobals_file="${HOME}/.config/kdeglobals"

mkdir -p "${kitty_dir}"

cp \
  "${root_dir}/repositories/packages/kitty/config/kitty.conf" \
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

"${root_dir}/scripts/update_bashrc.sh" "kitty" <<'EOF'
[ "${TERM}" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"
EOF

exit 0
