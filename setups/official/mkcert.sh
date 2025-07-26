#!/bin/bash
set -eu

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

if [ -f "${HOME}/.local/share/mkcert/rootCA.pem" ] && [ -f "${HOME}/.local/share/mkcert/rootCA-key.pem" ]; then
  info_msg "The local CA is already installed, skipping"
  exit 0
fi

mkcert -install 2>&1 | tee -a "./install.log" >/dev/null

exit 0
