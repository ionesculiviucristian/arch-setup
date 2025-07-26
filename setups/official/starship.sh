#!/bin/bash
set -eu

# https://github.com/starship/starship?tab=readme-ov-file#step-2-set-up-your-shell-to-use-starship
# https://starship.rs/config/
# https://github.com/catppuccin/starship

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

starship_dir="${HOME}/.config/starship"

_mkdir "${starship_dir}/themes"

_cp \
  "./configs/.config/starship/config.toml" \
  "${starship_dir}/config.toml"

download \
  "${starship_dir}/themes/mocha.conf" \
  https://raw.githubusercontent.com/catppuccin/starship/refs/heads/main/themes/mocha.toml

cat \
  "${starship_dir}/config.toml" \
  "${starship_dir}/themes/mocha.conf" \
  > "${HOME}/.config/.starship.toml"

./scripts/update_bashrc.sh 'eval "$(starship init bash)"'

exit 0
