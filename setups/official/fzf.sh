#!/bin/bash
set -eu

# https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration
# https://github.com/catppuccin/fzf

catppuccin_fzf_dir="${HOME}/.repos/catppuccin-fzf"

rm -rf "${catppuccin_fzf_dir}"

git clone -q https://github.com/catppuccin/fzf.git "${catppuccin_fzf_dir}"

./scripts/update_bashrc.sh 'eval "$(fzf --bash)"'
./scripts/update_bashrc.sh 'source "${HOME}/.repos/catppuccin-fzf/themes/catppuccin-fzf-mocha.sh"'

exit 0
