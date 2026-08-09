#!/bin/bash
set -eu

# [shell] https://github.com/pyenv/pyenv?tab=readme-ov-file#bash

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

export PYENV_ROOT="${HOME}/.pyenv"
[[ -d ${PYENV_ROOT}/bin ]] && export PATH="${PYENV_ROOT}/bin:${PATH}"
eval "$(pyenv init - bash)"

# pyenv install --skip-existing 3.10
# pyenv install --skip-existing 3.11
# pyenv install --skip-existing 3.12
pyenv install --skip-existing 3.13

"${root_dir}/scripts/setup_shell.sh" \
  --package "pyenv" \
  --priority "20" \
  "${package_dir}/bashrc.sh"

#export PYTHONPYCACHEPREFIX="${HOME}/.cache/python"

exit 0
