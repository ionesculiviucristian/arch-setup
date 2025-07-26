#!/bin/bash
set -eu

# https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration
# https://junegunn.github.io/fzf/tips/ripgrep-integration/
# https://github.com/catppuccin/fzf

# ./scripts/update_bashrc.sh 'eval "$(fzf --bash)"'

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

catppuccin_fzf_dir="${HOME}/.repos/catppuccin-fzf"

_rmdir "${catppuccin_fzf_dir}"

git_clone https://github.com/catppuccin/fzf.git "${catppuccin_fzf_dir}"

./scripts/update_bashrc.sh 'source "${HOME}/.repos/catppuccin-fzf/themes/catppuccin-fzf-mocha.sh"'

exit 0
