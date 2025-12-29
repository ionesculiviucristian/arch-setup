#!/bin/bash
set -eu

# [Theme] https://github.com/catppuccin/vim

# shellcheck source=../../../themes/base/official/vim.sh
source "./themes/base/official/vim.sh"

install_vim_theme

cp "./configs/.vimrc" "${HOME}/.vimrc"

exit 0
