#!/bin/bash
set -eu

# [Config] https://github.com/PapirusDevelopmentTeam/papirus-folders?tab=readme-ov-file#script-usage

papirus-folders -C violet --theme Papirus-Dark >/dev/null

kwriteconfig6 \
  --file "${HOME}/.config/kdeglobals" \
  --group "Icons" \
  --key "Theme" \
  "Papirus-Dark"

exit 0
