#!/bin/bash
set -eu

# shellcheck disable=SC2046
sudo pacman \
  -Syu \
  --needed \
  --noconfirm \
  $(<"./data/lists/b450-i-aorus-pro-wifi/drivers.txt") >/dev/null

exit 0
