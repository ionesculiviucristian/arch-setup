#!/bin/bash
set -eu

# [Default config] https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

lazygit_config_dir="${HOME}/.config/lazygit"

mkdir -p "${lazygit_config_dir}"

cp \
  "${package_dir}/config/config.yml" \
  "${lazygit_config_dir}/config.yml"

"${root_dir}/scripts/setup_shell.sh" \
  --package "lazygit" \
  --priority "50" \
  "${package_dir}/bashrc.sh"

exit 0
