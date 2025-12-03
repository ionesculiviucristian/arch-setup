#!/bin/bash
set -eu

# [Config] https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
# [Theme] https://github.com/catppuccin/lazygit

lazygit_dir="${HOME}/.config/lazygit"

mkdir -p "${lazygit_dir}"

wget -qO \
  "${lazygit_dir}/mocha-mauve.yml" \
  https://raw.githubusercontent.com/catppuccin/lazygit/refs/heads/main/themes-mergable/mocha/mauve.yml

cp \
  "./configs/.config/lazygit/config.yml" \
  "${lazygit_dir}/config.yml"

./scripts/update_bashrc.sh "lazygit" << 'EOF'
# https://github.com/catppuccin/lazygit?tab=readme-ov-file#if-you-want-to-use-our-preset
export LG_CONFIG_FILE="${HOME}/.config/lazygit/config.yml,${HOME}/.config/lazygit/mocha-mauve.yml"
EOF

exit 0
