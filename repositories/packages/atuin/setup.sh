#!/bin/bash
set -eu

# [config] https://docs.atuin.sh/latest/configuration/config/
# [shell] https://docs.atuin.sh/latest/guide/installation/#__tabbed_2_2

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

atuin_config_dir="${HOME}/.config/atuin"

mkdir -p "${atuin_config_dir}"

cp \
  "${package_dir}/config/config.toml" \
  "${atuin_config_dir}/config.toml"

"${root_dir}/scripts/setup_shell.sh" \
  --package "atuin" \
  --priority "80" \
  "${package_dir}/bashrc.sh"

exit 0
