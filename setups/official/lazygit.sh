#!/bin/bash
set -eu

# https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
# https://github.com/catppuccin/lazygit

lazygit_dir="${HOME}/.config/lazygit"

mkdir -p "${lazygit_dir}"

wget -qO \
  "${lazygit_dir}/mocha-mauve.yml" \
  https://raw.githubusercontent.com/catppuccin/lazygit/refs/heads/main/themes-mergable/mocha/mauve.yml

cp \
  "./configs/.config/lazygit/config.yml" \
  "${lazygit_dir}/config.yml"

./scripts/update_bashrc.sh << 'EOF'
# Merge lazygit config files
export LG_CONFIG_FILE="${HOME}/.config/lazygit/config.yml,${HOME}/.config/lazygit/mocha-mauve.yml"
EOF

exit 0
