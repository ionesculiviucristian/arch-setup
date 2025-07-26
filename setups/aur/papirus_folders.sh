#!/bin/bash
set -eu

papirus-folders -C violet --theme Papirus-Dark 2>&1 | tee "./install.log"

kwriteconfig6 \
  --file "${HOME}/.config/kdeglobals" \
  --group "Icons" \
  --key "Theme" \
  "Papirus-Dark"

exit 0
