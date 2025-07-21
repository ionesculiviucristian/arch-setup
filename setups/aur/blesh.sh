#!/bin/bash
set -eu

# https://github.com/akinomyoga/ble.sh?tab=readme-ov-file#13-set-up-bashrc
# https://github.com/akinomyoga/ble.sh/blob/master/blerc.template

cp \
  "./configs/.blerc" \
  "${HOME}/.blerc"

./scripts/update_bashrc.sh '[[ $- == *i* ]] && source -- "/usr/share/blesh/ble.sh" --attach=none --rcfile "${HOME}/.blerc"'

exit 0
