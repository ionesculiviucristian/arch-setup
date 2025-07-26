#!/bin/bash
set -eu

# https://github.com/akinomyoga/ble.sh?tab=readme-ov-file#13-set-up-bashrc
# https://github.com/akinomyoga/ble.sh/blob/master/blerc.template

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

_cp \
  "./configs/.blerc" \
  "${HOME}/.blerc"

./scripts/update_bashrc.sh '[[ $- == *i* ]] && source -- "/usr/share/blesh/ble.sh" --attach=none --rcfile "${HOME}/.blerc"'

exit 0
