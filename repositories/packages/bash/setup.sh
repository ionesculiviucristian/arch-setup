#!/bin/bash
set -eu

# @see [config](https://www.gnu.org/software/bash/manual/bash.html)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

install -D -m 644 \
  "${package_dir}/config/.bash_aliases" \
  "${HOME}/.bash_aliases"

install -D -m 644 \
  "${package_dir}/config/.bash_aliases_help" \
  "${HOME}/.bash_aliases_help"

bash::install_bashrc \
  --package "bash" \
  --priority "10" \
  "${package_dir}/bashrc.sh"

exit 0
