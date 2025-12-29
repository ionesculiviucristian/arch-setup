#!/bin/bash
set -eu

# [Config] https://github.com/aristocratos/btop?tab=readme-ov-file#configurability
# [Theme] https://github.com/catppuccin/btop

# shellcheck source=../_config.sh
source "./setups/base/_config.sh"

# shellcheck source=../../../themes/base/official/btop.sh
source "./themes/base/official/btop.sh"

install_btop_theme

cp \
  "./configs/.config/btop/btop.conf" \
  "${btop_dir}/btop.conf"

exit 0
