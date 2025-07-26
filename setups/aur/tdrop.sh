#!/bin/bash
set -eu

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

applications_dir="${HOME}/.local/share/applications"

_mkdir "${applications_dir}"

kwriteconfig6 \
  --file "${HOME}/.config/kglobalshortcutsrc" \
  --group "services" \
  --group "net.local.tdrop.desktop" \
  --key "_launch" \
  "Alt+F12"

__cp \
  "./configs/.local/share/applications/net.local.tdrop.desktop" \
  "${applications_dir}/net.local.tdrop.desktop"

exit 0
