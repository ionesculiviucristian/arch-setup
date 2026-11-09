#!/bin/bash
set -eu

# @see [tools](https://go.dev/ref/mod#go-install)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

while read -r tool; do
  go install "${tool}"
done <"${package_dir}/tools.txt"

exit 0
