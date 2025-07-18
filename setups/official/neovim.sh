#!/bin/bash
set -eu

# https://github.com/folke/lazy.nvim
# https://github.com/catppuccin/nvim

cp -r \
  "./configs/.config/nvim" \
  "${HOME}/.config"

exit 0
