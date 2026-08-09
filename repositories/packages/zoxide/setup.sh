#!/bin/bash
set -eu

# [shell] https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

"${root_dir}/scripts/setup_shell.sh" \
  --package "zoxide" \
  --priority "50" \
  "${package_dir}/bashrc.sh"

exit 0
