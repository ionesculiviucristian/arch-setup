#!/bin/bash
set -eu

# @see [shell](https://github.com/starship/starship?tab=readme-ov-file#step-2-set-up-your-shell-to-use-starship)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

bash::install_bashrc \
  --package "starship" \
  --priority "90" \
  "${package_dir}/bashrc.sh"

exit 0
