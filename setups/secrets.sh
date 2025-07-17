#!/bin/bash
set -eu

email="$1"

if [ -z "${email}" ]; then
  echo "Error: No email provided"
  exit 1
fi

# shellcheck disable=SC1091
source "${HOME}/.bashrc"

BW_SESSION=$(bw login "${email}" --method 0 --raw)
export BW_SESSION

bw get item "Private bash aliases" | jq -r '.notes' > "${HOME}/.bash_private_aliases"
bw get item "Arch setup" | jq -r '.notes' > "./env"
bw get item "GPG private key" | jq -r '.notes' | gpg --import
bw get item "GPG public key" | jq -r '.notes' | gpg --import

bw logout

exit 0
