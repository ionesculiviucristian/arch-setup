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

nvim_config_dir="${HOME}/.config/nvim"

if [ ! -e "${nvim_config_dir}" ] && [ ! -L "${nvim_config_dir}" ]; then
  install -D -m 644 \
    "${package_dir}/config/init.lua" \
    "${nvim_config_dir}/init.lua"

  install -D -m 644 \
    "${package_dir}/config/lua/plugins/catppuccin.lua" \
    "${nvim_config_dir}/lua/plugins/catppuccin.lua"
fi

exit 0
