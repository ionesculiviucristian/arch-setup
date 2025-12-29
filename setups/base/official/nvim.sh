#!/bin/bash
set -eu

# shellcheck source=../_config.sh
source "./setups/base/_config.sh"

mkdir -p "${nvim_dir}"

cp -r \
  "./configs/.config/nvim/"* \
  "${nvim_dir}"

exit 0
