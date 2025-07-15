#!/bin/bash
set -eu

line="$1"
pre="${2:-}"
post="${3:-}"

if [ -z "${line}" ]; then
  echo "Error: No line provided"
  exit 1
fi

if ! grep -Fxq "${line}" "${HOME}/.bashrc"; then
  echo -e "${pre}${line}${post}" >> "${HOME}/.bashrc"
fi

exit 0
