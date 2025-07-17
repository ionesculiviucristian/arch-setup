#!/bin/bash
set -eu

starship_dir="${HOME}/.config/starship"

mkdir -p "${starship_dir}/themes"

cp \
  "./configs/.config/starship/config.toml" \
  "${starship_dir}/config.toml"

touch "${HOME}/.config/.starship.toml"

./scripts/update_bashrc.sh 'eval "$(starship init bash)"'

wget -qO \
  "${starship_dir}/themes/mocha.conf" \
  https://raw.githubusercontent.com/catppuccin/starship/refs/heads/main/themes/mocha.toml

cat \
  "${starship_dir}/config.toml" \
  "${starship_dir}/themes/mocha.conf" \
  > "${HOME}/.config/.starship.toml"

exit 0
