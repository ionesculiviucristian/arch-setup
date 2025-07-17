#!/bin/bash
set -eu

cp "./configs/.blerc" "${HOME}/.blerc"

./scripts/update_bashrc.sh '[[ $- == *i* ]] && source -- "/usr/share/blesh/ble.sh" --attach=none --rcfile "${HOME}/.blerc"'

exit 0
