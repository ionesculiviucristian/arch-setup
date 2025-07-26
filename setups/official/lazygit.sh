#!/bin/bash
set -eu

# https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
# https://github.com/catppuccin/lazygit

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

lazygit_dir="${HOME}/.config/lazygit"

_mkdir "${lazygit_dir}"

download \
  "${lazygit_dir}/mocha-mauve.yml" \
  https://raw.githubusercontent.com/catppuccin/lazygit/refs/heads/main/themes-mergable/mocha/mauve.yml

_cp \
  "./configs/.config/lazygit/config.yml" \
  "${lazygit_dir}/config.yml"

./scripts/update_bashrc.sh 'export LG_CONFIG_FILE="${HOME}/.config/lazygit/config.yml,${HOME}/.config/lazygit/mocha-mauve.yml"'

exit 0
