#!/bin/bash
set -eu

insert_new_line=${1:-true}

basrc_file="${HOME}/.bashrc"

inserted_new_line=false

if [ "${insert_new_line}" = false ]; then
  inserted_new_line=true
fi

while IFS= read -r line; do
  if ! grep -Fxq "${line}" "${basrc_file}"; then
    if [ "${inserted_new_line}" = false ]; then
      echo "" >> "${basrc_file}"
      inserted_new_line=true
    fi
    echo "${line}" >> "${basrc_file}"
  fi
done

exit 0
