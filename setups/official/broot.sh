#!/bin/bash
set -eu

# https://dystroy.org/broot/install-br/#automatic-shell-function-installation
# https://github.com/catppuccin/catppuccin/discussions/1848

broot --install 2>&1 | tee -a "./install.log" >/dev/null

exit 0
