#!/bin/bash
set -eu

# [config] https://github.com/sharkdp/bat?tab=readme-ov-file#configuration-file
# [shell] https://github.com/sharkdp/bat?tab=readme-ov-file#man

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

bat_config_dir="${HOME}/.config/bat"

mkdir -p "${bat_config_dir}"

cp \
  "${package_dir}/config/config" \
  "${bat_config_dir}/config"

"${root_dir}/scripts/setup_shell.sh" \
  --package "bat" \
  --priority "20" \
  "${package_dir}/bashrc.sh"

exit 0
