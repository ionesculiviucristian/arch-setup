#!/bin/bash
set -eu

# shellcheck disable=SC2046
yay \
  -Syu \
  --needed \
  --noconfirm \
  $(<"./data/lists/b450-i-aorus-pro-wifi/aur.txt") >/dev/null

exit 0
