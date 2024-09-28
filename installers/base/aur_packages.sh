#!/bin/bash
set -eu

# shellcheck disable=SC2046
yay \
  -Syu \
  --needed \
  --noconfirm \
  $(<"./data/lists/base/aur.txt") >/dev/null

exit 0
