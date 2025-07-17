#!/bin/bash
set -eu

mkdir -p "${HOME}/.local/share/applications"

cp "./configs/.local/share/applications/net.local.tdrop.desktop" "${HOME}/.local/share/applications/net.local.tdrop.desktop"

kwriteconfig6 --file "${HOME}/.config/kglobalshortcutsrc" --group "services" --group "net.local.tdrop.desktop" --key "_launch" "Alt+F12"

exit 0
