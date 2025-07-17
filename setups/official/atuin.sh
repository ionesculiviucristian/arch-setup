#!/bin/bash
set -eu

mkdir -p "${HOME}/.config/atuin"

cp "./configs/.config/atuin/config.toml" "${HOME}/.config/atuin/config.toml"

./scripts/update_bashrc.sh 'eval "$(atuin init bash)"'

atuin_dir="${HOME}/.config/atuin/themes"

mkdir -p "${atuin_dir}"

wget -qO \
  "${atuin_dir}/themes/catppuccin-mocha-mauve.toml" \
  https://raw.githubusercontent.com/catppuccin/atuin/refs/heads/main/themes/mocha/catppuccin-mocha-mauve.toml 

exit 0
