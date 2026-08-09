#!/bin/bash
set -eu

# @see [shell](https://github.com/direnv/direnv/blob/master/docs/hook.md#bash)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

bash::install_bashrc \
  --package "direnv" \
  --priority "50" \
  "${package_dir}/bashrc.sh"

exit 0
