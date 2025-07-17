#!/bin/bash
set -eu

wget -qO- https://git.io/papirus-folders-install | sh

kwriteconfig6 --file "${HOME}/.config/kdeglobals" --group "Icons" --key "Theme" "Papirus-Dark"

papirus-folders -C violet --theme Papirus-Dark

exit 0
