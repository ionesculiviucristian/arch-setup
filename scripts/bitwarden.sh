#!/bin/bash
set -eu

login_bitwarden() {
  local email=$1

  if [ -z "${email}" ]; then
    echo "Error: E-mail is required"
    exit 1
  fi

  BW_SESSION=$(bw login "${email}" --method 0 --raw)
  export BW_SESSION
}

read_bitwarden_entry() {
  local item=$1
  local field=${2:-.notes}

  bw get item "${item}" | jq -r "${field}"
}

logout_bitwarden() {
  bw logout
}
