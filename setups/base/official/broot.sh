#!/bin/bash
set -eu

# [bashrc] https://dystroy.org/broot/install-br/#automatic-shell-function-installation
# [Theme] https://github.com/catppuccin/broot

# shellcheck source=../_config.sh
source "./setups/base/_config.sh"

# shellcheck source=../../../themes/base/official/broot.sh
source "./themes/base/official/broot.sh"

broot --install >/dev/null
broot --write-default-conf "${broot_dir}"

install_broot_theme

exit 0
