#!/bin/bash
set -eu

# shellcheck disable=SC2046
sudo pacman \
  -Syu \
  --needed \
  --noconfirm \
  $(<"./data/lists/base/official.txt") >/dev/null

exit 0
