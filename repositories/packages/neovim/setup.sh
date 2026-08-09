#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# Neovim configuration lives in the sibling neovim-config project
config_dir="${root_dir}/../neovim-config/config"

nvim_config_dir="${HOME}/.config/nvim"

if [ ! -d "${config_dir}" ]; then
  echo "neovim: config not found at ${config_dir}" >&2
  echo "neovim: clone the neovim-config project next to arch-setup" >&2
  exit 1
fi

mkdir -p "${nvim_config_dir}"

cp -r \
  "${config_dir}/"* \
  "${nvim_config_dir}"

"${root_dir}/scripts/setup_shell.sh" \
  --package "neovim" \
  --priority "20" \
  "${package_dir}/bashrc.sh"

exit 0
