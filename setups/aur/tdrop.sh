#!/bin/bash
set -eu

applications_dir="${HOME}/.local/share/applications"

mkdir -p "${applications_dir}"

cp \
  "./configs/.local/share/applications/net.local.tdrop.desktop" \
  "${applications_dir}/net.local.tdrop.desktop"

kwriteconfig6 \
  --file "${HOME}/.config/kglobalshortcutsrc" \
  --group "services" \
  --group "net.local.tdrop.desktop" \
  --key "_launch" \
  "Alt+F12"

exit 0
