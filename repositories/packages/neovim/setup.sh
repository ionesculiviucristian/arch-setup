#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

nvim_dir="${HOME}/.config/nvim"

mkdir -p "${nvim_dir}"

cp -r \
  "${root_dir}/repositories/packages/neovim/config/"* \
  "${nvim_dir}"

exit 0
