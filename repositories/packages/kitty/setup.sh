#!/bin/bash
set -eu

# @see [config](https://sw.kovidgoyal.net/kitty/conf/#kitty-conf)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

applications_dir="${HOME}/.local/share/applications"
kitty_config_dir="${HOME}/.config/kitty"
kdeglobals_file="${HOME}/.config/kdeglobals"

install -D -m 644 \
  "${package_dir}/config/kitty.conf" \
  "${kitty_config_dir}/kitty.conf"

install -D -m 644 \
  "${package_dir}/config/net.local.quick-access-terminal.desktop" \
  "${applications_dir}/net.local.quick-access-terminal.desktop"

kwriteconfig6 \
  --file "${HOME}/.config/kglobalshortcutsrc" \
  --group "services" \
  --group "net.local.quick-access-terminal.desktop" \
  --key "_launch" \
  "Alt+F12"

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

bash::install_bashrc \
  --package "kitty" \
  --priority "50" \
  "${package_dir}/bashrc.sh"

exit 0
