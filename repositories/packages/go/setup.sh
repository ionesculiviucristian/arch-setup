#!/bin/bash
set -eu

# @see [shell](https://go.dev/doc/install#install)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

"${package_dir}/install-go-tools.sh"

bash::install_bashrc \
  --package "go" \
  --priority "20" \
  "${package_dir}/bashrc.sh"

exit 0
