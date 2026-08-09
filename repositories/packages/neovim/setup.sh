#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

# Neovim configuration lives in the sibling neovim-config project
config_dir="${root_dir}/../neovim-config/config"

nvim_dir="${HOME}/.config/nvim"

if [ ! -d "${config_dir}" ]; then
  echo "neovim: config not found at ${config_dir}" >&2
  echo "neovim: clone the neovim-config project next to arch-setup" >&2
  exit 1
fi

mkdir -p "${nvim_dir}"

cp -r \
  "${config_dir}/"* \
  "${nvim_dir}"

exit 0
