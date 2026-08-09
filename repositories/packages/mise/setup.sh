#!/bin/bash
set -eu

# @see [config](https://mise.jdx.dev/configuration.html)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

mise use --global node@26
mise exec -- npm install -g npm@latest npm-check-updates

bash::install_bashrc \
  --package "mise" \
  --priority "20" \
  "${package_dir}/bashrc.sh"

exit 0
