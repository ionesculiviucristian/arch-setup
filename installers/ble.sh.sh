#!/bin/bash
set -eu

git clone --recursive https://github.com/akinomyoga/ble.sh.git "${HOME}/.repos/ble.sh"

(
  cd "${HOME}/.repos/ble.sh"
  make
  make INSDIR="${HOME}/.local/share/blesh" install
)

touch "${HOME}/.blerc"

echo '[[ $- == *i* ]] && source "${HOME}/.local/share/blesh/ble.sh" --rcfile "${HOME}/.blerc"' >> "${HOME}/.bashrc"
echo '[[ ! ${BLE_VERSION-} ]] || ble-attach' >> "${HOME}/.bashrc"
