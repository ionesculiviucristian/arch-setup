#!/bin/bash
set -eu

# [shell] https://github.com/direnv/direnv/blob/master/docs/hook.md#bash

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

"${root_dir}/scripts/setup_shell.sh" \
  --package "direnv" \
  --priority "50" \
  "${package_dir}/bashrc.sh"

exit 0
