#!/bin/bash
set -eu

nvim_dir="${HOME}/.config/nvim"

mkdir -p "${nvim_dir}"

cp -r \
  "./configs/.config/nvim/"* \
  "${nvim_dir}"

exit 0
