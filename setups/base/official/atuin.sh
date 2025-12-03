#!/bin/bash
set -eu

# [bashrc] https://docs.atuin.sh/guide/installation/#installing-the-shell-plugin
# [Config] https://docs.atuin.sh/configuration/config/
# [Theme] https://github.com/catppuccin/atuin?tab=readme-ov-file#usage

atuin_dir="${HOME}/.config/atuin"
atuin_theme="catppuccin-mocha-mauve"

mkdir -p "${atuin_dir}/themes"

wget -qO \
  "${atuin_dir}/themes/${atuin_theme}.toml" \
  https://raw.githubusercontent.com/catppuccin/atuin/refs/heads/main/themes/mocha/${atuin_theme}.toml 

cp \
  "./configs/.config/atuin/config.toml" \
  "${atuin_dir}/config.toml"

./scripts/update_bashrc.sh "atuin" << 'EOF'
# https://docs.atuin.sh/guide/installation/#installing-the-shell-plugin
eval "$(atuin init bash)"
EOF

exit 0
