#!/bin/bash
set -eu

package_files="./data/packages/*.json"

for package_file in ${package_files}; do
  lists_dir="./data/lists/$(basename "${package_file}" .json)"

  mkdir -p "${lists_dir}"

  jq -r 'keys_unsorted[] | select(. != "external")' "${package_file}" | \
    while read -r list; do
      jq --arg section_name "${list}" -r '
        .[$section_name]
        | sort_by(.name)
        | .[] | .name
      ' "${package_file}" > "${lists_dir}/${list}.txt"
    done
done

exit 0
