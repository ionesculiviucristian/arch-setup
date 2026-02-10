#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

applications_dir="${HOME}/.local/share/applications"

mkdir -p "${applications_dir}"

cp \
  "${root_dir}/repositories/packages/tdrop/config/net.local.tdrop.desktop" \
  "${applications_dir}/net.local.tdrop.desktop"

kwriteconfig6 \
  --file "${HOME}/.config/kglobalshortcutsrc" \
  --group "services" \
  --group "net.local.tdrop.desktop" \
  --key "_launch" \
  "Alt+F12"

exit 0
