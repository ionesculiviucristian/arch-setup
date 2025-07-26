#!/bin/bash
set -eu

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

_cp \
  "./configs/powerdevilrc" \
  "${HOME}/.config/powerdevilrc"

exit 0
