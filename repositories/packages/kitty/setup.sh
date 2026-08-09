#!/bin/bash
set -eu

# [config] https://sw.kovidgoyal.net/kitty/conf/#kitty-conf

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

kitty_config_dir="${HOME}/.config/kitty"
kdeglobals_file="${HOME}/.config/kdeglobals"

mkdir -p "${kitty_config_dir}"

cp \
  "${package_dir}/config/kitty.conf" \
  "${kitty_config_dir}/kitty.conf"

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

"${root_dir}/scripts/setup_shell.sh" \
  --package "kitty" \
  --priority "50" \
  "${package_dir}/bashrc.sh"

exit 0
