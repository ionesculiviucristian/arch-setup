#!/bin/bash
set -eu

# https://docs.atuin.sh/configuration/config/
# https://github.com/catppuccin/atuin?tab=readme-ov-file#usage

atuin_dir="${HOME}/.config/atuin"

mkdir -p "${atuin_dir}/themes"

wget -qO \
  "${atuin_dir}/themes/catppuccin-mocha-mauve.toml" \
  https://raw.githubusercontent.com/catppuccin/atuin/refs/heads/main/themes/mocha/catppuccin-mocha-mauve.toml 

cp \
  "./configs/.config/atuin/config.toml" \
  "${atuin_dir}/config.toml"

./scripts/update_bashrc.sh << 'EOF'
# Initialize Atuin
# https://docs.atuin.sh/guide/installation/#installing-the-shell-plugin
eval "$(atuin init bash)"
EOF

exit 0
