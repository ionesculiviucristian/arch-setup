#!/bin/bash
set -eu

# https://docs.atuin.sh/guide/installation/#installing-the-shell-plugin
# https://docs.atuin.sh/configuration/config/
# https://github.com/catppuccin/atuin?tab=readme-ov-file#usage

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

atuin_dir="${HOME}/.config/atuin"

_mkdir "${atuin_dir}/themes"

download \
  "${atuin_dir}/themes/catppuccin-mocha-mauve.toml" \
  https://raw.githubusercontent.com/catppuccin/atuin/refs/heads/main/themes/mocha/catppuccin-mocha-mauve.toml 

_cp \
  "./configs/.config/atuin/config.toml" \
  "${atuin_dir}/config.toml"

./scripts/update_bashrc.sh 'eval "$(atuin init bash)"'

exit 0
