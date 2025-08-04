#!/bin/bash
set -eu

# shellcheck disable=SC2046
sudo pacman \
  -Syu \
  --needed \
  --noconfirm \
  $(<"./data/lists/b450-i-aorus-pro-wifi/drivers.txt") >/dev/null

sudo systemctl enable xppentablet.service >/dev/null
sudo systemctl start xppentablet.service

exit 0
