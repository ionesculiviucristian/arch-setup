#!/bin/bash
set -eu

# @see [config](https://docs.atuin.sh/latest/configuration/config/)
# @see [shell](https://docs.atuin.sh/latest/guide/installation/#__tabbed_2_2)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

atuin_config_dir="${HOME}/.config/atuin"

install -D -m 644 \
  "${package_dir}/config/config.toml" \
  "${atuin_config_dir}/config.toml"

bash::install_bashrc \
  --package "atuin" \
  --priority "80" \
  "${package_dir}/bashrc.sh"

exit 0
