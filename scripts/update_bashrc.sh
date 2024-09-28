#!/bin/bash
set -eu

insert_new_line=${1:-true}

bashrc_file="${HOME}/.bashrc"

inserted_new_line=false

if [ "${insert_new_line}" = false ]; then
  inserted_new_line=true
fi

while IFS= read -r line; do
  if ! grep -qFx "${line}" "${bashrc_file}"; then
    if [ "${inserted_new_line}" = false ]; then
      echo "" >> "${bashrc_file}"
      inserted_new_line=true
    fi
    echo "${line}" >> "${bashrc_file}"
  fi
done

exit 0
