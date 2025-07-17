#!/bin/bash
set -eu

# https://docs.atuin.sh/guide/installation/
# https://github.com/catppuccin/atuin?tab=readme-ov-file#usage

atuin_dir="${HOME}/.config/atuin"

mkdir -p "${atuin_dir}/themes"

wget -qO \
  "${atuin_dir}/themes/catppuccin-mocha-mauve.toml" \
  https://raw.githubusercontent.com/catppuccin/atuin/refs/heads/main/themes/mocha/catppuccin-mocha-mauve.toml 

cp \
  "./configs/.config/atuin/config.toml" \
  "${atuin_dir}/config.toml"

./scripts/update_bashrc.sh 'eval "$(atuin init bash)"'

exit 0
