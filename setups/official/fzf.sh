#!/bin/bash
set -eu

# https://junegunn.github.io/fzf/tips/ripgrep-integration/
# https://github.com/catppuccin/fzf

# ./scripts/update_bashrc.sh 'eval "$(fzf --bash)"'

catppuccin_fzf_dir="${HOME}/.repos/catppuccin-fzf"

rm -rf "${catppuccin_fzf_dir}"

git clone -q https://github.com/catppuccin/fzf.git "${catppuccin_fzf_dir}"

./scripts/update_bashrc.sh << 'EOF'
# Initialize fzf
# https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration
source "${HOME}/.repos/catppuccin-fzf/themes/catppuccin-fzf-mocha.sh"
EOF

exit 0
