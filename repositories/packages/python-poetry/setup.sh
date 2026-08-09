#!/bin/bash
set -eu

# [shell] https://python-poetry.org/docs/main/#installing-with-the-official-installer

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

export PATH="${HOME}/.local/bin:${PATH}"

poetry completions bash >>"${HOME}/.bash_completion"

"${root_dir}/scripts/setup_shell.sh" \
  --package "poetry" \
  --priority "20" \
  "${package_dir}/bashrc.sh"

exit 0
