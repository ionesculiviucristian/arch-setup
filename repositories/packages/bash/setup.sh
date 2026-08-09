#!/bin/bash
set -eu

# [config] https://www.gnu.org/software/bash/manual/bash.html

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

cp \
  "${package_dir}/config/.bash_aliases" \
  "${HOME}/.bash_aliases"

cp \
  "${package_dir}/config/.bash_aliases_help" \
  "${HOME}/.bash_aliases_help"

"${root_dir}/scripts/setup_shell.sh" \
  --package "bash" \
  --priority "10" \
  "${package_dir}/bashrc.sh"

exit 0
