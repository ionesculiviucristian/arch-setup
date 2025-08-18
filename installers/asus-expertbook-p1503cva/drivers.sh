#!/bin/bash
set -eu

# shellcheck disable=SC2046
sudo pacman \
  -Syu \
  --needed \
  --noconfirm \
  $(<"./data/lists/asus-expertbook-p1503cva/drivers.txt") >/dev/null

exit 0
