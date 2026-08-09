#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

bash::install_bashrc \
  --package "neovim" \
  --priority "20" \
  "${package_dir}/bashrc.sh"

exit 0
