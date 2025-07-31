#!/bin/bash
set -eu

data_file="./data/packages.json"

if [ ! -f "${data_file}" ]; then
  echo "Error: ${data_file} not found"
  exit 1
fi

jq -r 'keys_unsorted[] | select(. != "external")' "${data_file}" | \
  while read -r list; do
    list_file="./data/lists/${list}.txt"

    jq --arg section_name "${list}" -r '
      .[$section_name]
      | sort_by(.name)
      | .[] | .name
    ' "${data_file}" > "${list_file}"
  done

exit 0
