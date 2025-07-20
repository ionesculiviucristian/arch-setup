#!/bin/bash
set -eu

wget -qO- https://git.io/papirus-folders-install | sh

papirus-folders -C violet --theme Papirus-Dark

kwriteconfig6 \
  --file "${HOME}/.config/kdeglobals" \
  --group "Icons" \
  --key "Theme" \
  "Papirus-Dark"

exit 0
