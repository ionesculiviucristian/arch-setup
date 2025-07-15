#!/bin/bash
set -eu

data_file="./data/packages.json"

jq -r 'keys_unsorted[] | select(. != "external")' "${data_file}" | while read -r section; do
  packages_file="./data/lists/${section}.txt"

  jq --arg section_name "$section" -r '
    .[$section_name]
    | sort_by(.name)
    | .[] | .name
  ' "${data_file}" > "${packages_file}"
done

exit 0
