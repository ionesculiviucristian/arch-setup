#!/bin/bash
set -eu

atuin_dir="${HOME}/.config/atuin"

mkdir -p "${atuin_dir}/themes"

cp \
  "./configs/.config/atuin/config.toml" \
  "${atuin_dir}/config.toml"

./scripts/update_bashrc.sh 'eval "$(atuin init bash)"'

wget -qO \
  "${atuin_dir}/themes/catppuccin-mocha-mauve.toml" \
  https://raw.githubusercontent.com/catppuccin/atuin/refs/heads/main/themes/mocha/catppuccin-mocha-mauve.toml 

exit 0
