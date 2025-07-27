#!/bin/bash
set -eu

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

line="$1"
pre="${2:-}"
post="${3:-}"

basrc_file="${HOME}/.bashrc"

if [ -z "${line}" ]; then
  echo "Error: No line provided"
  exit 1
fi

if [ ! -f "${basrc_file}" ]; then
  echo "Error: ${basrc_file} not found"
  exit 1
fi

if ! grep -Fxq "${line}" "${basrc_file}"; then
  inform "Inserting line ${pre}${line}${post} in ${basrc_file}"
  echo -e "${pre}${line}${post}" >> "${basrc_file}"
fi

exit 0
