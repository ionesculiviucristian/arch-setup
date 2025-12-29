#!/bin/bash
set -eu

# [bashrc] https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration
# [Config] https://junegunn.github.io/fzf/tips/ripgrep-integration/
# [Theme] https://github.com/catppuccin/fzf

# shellcheck source=../../../themes/base/official/fzf.sh
source "./themes/base/official/fzf.sh"

install_fzf_theme

./scripts/update_bashrc.sh "fzf" << 'EOF'
# https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration
source "${HOME}/.repos/catppuccin-fzf/themes/catppuccin-fzf-mocha.sh"
EOF

exit 0
