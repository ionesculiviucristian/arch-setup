#!/bin/bash
set -eu

# [Config] https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
# [Theme] https://github.com/catppuccin/lazygit

# shellcheck source=../_config.sh
source "./setups/base/_config.sh"

# shellcheck source=../../../themes/base/official/lazygit.sh
source "./themes/base/official/lazygit.sh"

install_lazygit_theme

cp \
  "./configs/.config/lazygit/config.yml" \
  "${lazygit_dir}/config.yml"

./scripts/update_bashrc.sh "lazygit" << 'EOF'
# https://github.com/catppuccin/lazygit?tab=readme-ov-file#if-you-want-to-use-our-preset
export LG_CONFIG_FILE="${HOME}/.config/lazygit/config.yml,${HOME}/.config/lazygit/mocha-mauve.yml"
EOF

exit 0
