#!/bin/bash
set -eu

./scripts/update_bashrc.sh 'eval "$(fzf --bash)"'

catppuccin_fzf_dir="${HOME}/.repos/catppuccin-fzf"

rm -rf "${catppuccin_fzf_dir}"

git clone -q https://github.com/catppuccin/fzf.git "${catppuccin_fzf_dir}"

./update_bashrc.sh 'source "${HOME}/.repos/catppuccin-fzf/themes/catppuccin-fzf-mocha.sh"'

exit 0
