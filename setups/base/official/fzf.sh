#!/bin/bash
set -eu

# [bashrc] https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration
# [Config] https://junegunn.github.io/fzf/tips/ripgrep-integration/
# [Theme] https://github.com/catppuccin/fzf

# ./scripts/update_bashrc.sh << 'EOF'
# eval "$(fzf --bash)"
# EOF

catppuccin_fzf_dir="${HOME}/.repos/catppuccin-fzf"

rm -rf "${catppuccin_fzf_dir}"

git clone -q https://github.com/catppuccin/fzf.git "${catppuccin_fzf_dir}"

./scripts/update_bashrc.sh "fzf" << 'EOF'
# https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration
source "${HOME}/.repos/catppuccin-fzf/themes/catppuccin-fzf-mocha.sh"
EOF

exit 0
