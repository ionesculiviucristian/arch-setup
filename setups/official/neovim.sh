#!/bin/bash
set -eu

# https://github.com/folke/lazy.nvim
# https://github.com/catppuccin/nvim

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

_cpdir \
  "./configs/.config/nvim" \
  "${HOME}/.config"

exit 0
