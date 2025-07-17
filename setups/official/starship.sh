#!/bin/bash
set -eu

mkdir -p "${HOME}/.config/starship"

cp "./configs/.config/starship/config.toml" "${HOME}/.config/starship/config.toml"

touch "${HOME}/.config/.starship.toml"

if [ -f "${HOME}/.config/starship/themes/mocha.conf" ]; then
  cat \
    "${HOME}/.config/starship/config.toml" \
    "${HOME}/.config/starship/themes/mocha.conf" \
    > "${HOME}/.config/.starship.toml"
fi

./scripts/update_bashrc.sh 'eval "$(starship init bash)"'

starship_dir="${HOME}/.config/starship"

mkdir -p "${starship_dir}/themes"

wget -qO \
  "${starship_dir}/themes/mocha.conf" \
  https://raw.githubusercontent.com/catppuccin/starship/refs/heads/main/themes/mocha.toml

if [ -f "${starship_dir}/config.toml" ]; then
  cat \
    "${starship_dir}/config.toml" \
    "${starship_dir}/themes/mocha.conf" \
    > "${HOME}/.config/.starship.toml"
fi

exit 0
