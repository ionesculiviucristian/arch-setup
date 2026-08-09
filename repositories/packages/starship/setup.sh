#!/bin/bash
set -eu

# [config] https://starship.rs/config/
# [shell] https://github.com/starship/starship?tab=readme-ov-file#step-2-set-up-your-shell-to-use-starship

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

starship_config_dir="${HOME}/.config/starship"

mkdir -p "${starship_config_dir}"

cp \
  "${package_dir}/config/config.toml" \
  "${starship_config_dir}/config.toml"

"${root_dir}/scripts/setup_shell.sh" \
  --package "starship" \
  --priority "90" \
  "${package_dir}/bashrc.sh"

exit 0
