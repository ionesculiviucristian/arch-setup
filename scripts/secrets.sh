#!/bin/bash
set -eu

login_secrets() {
  local email=$1

  if [ -z "${email}" ]; then
    echo "Error: E-mail is required"
    exit 1
  fi

  BW_SESSION=$(bw login "${email}" --method 0 --raw)
  export BW_SESSION
}

read_secret() {
  local item=$1
  local field=${2:-notes}
  local path

  case "${field}" in
  notes)
    path=".notes"
    ;;
  ssh_public_key)
    path=".sshKey.publicKey"
    ;;
  *)
    echo "Error: Unknown secret field ${field}" >&2
    exit 1
    ;;
  esac

  bw get item "${item}" | jq --raw-output "${path}"
}

logout_secrets() {
  bw logout
}
