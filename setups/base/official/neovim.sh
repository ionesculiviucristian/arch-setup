#!/bin/bash
set -eu

# [Config] https://github.com/folke/lazy.nvim
# [Theme] https://github.com/catppuccin/nvim

sudo pacman -Syu --needed --noconfirm luarocks >/dev/null

cp -r "./configs/.config/nvim" "${HOME}/.config"

exit 0
