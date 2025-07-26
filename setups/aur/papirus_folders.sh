#!/bin/bash
set -eu

papirus-folders -C violet --theme Papirus-Dark >/dev/null

kwriteconfig6 \
  --file "${HOME}/.config/kdeglobals" \
  --group "Icons" \
  --key "Theme" \
  "Papirus-Dark"

exit 0
