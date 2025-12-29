#!/bin/bash
set -eu

# [bashrc] https://github.com/starship/starship?tab=readme-ov-file#step-2-set-up-your-shell-to-use-starship
# [Config] https://starship.rs/config/
# [Theme] https://github.com/catppuccin/starship

# shellcheck source=../_config.sh
source "./setups/base/_config.sh"

# shellcheck source=../../../themes/base/official/starship.sh
source "./themes/base/official/starship.sh"

install_starship_theme

cp \
  "./configs/.config/starship/config.toml" \
  "${starship_dir}/config.toml"

./scripts/update_bashrc.sh "starship" << 'EOF'
# https://github.com/starship/starship?tab=readme-ov-file#step-2-set-up-your-shell-to-use-starship
eval "$(starship init bash)"
EOF

exit 0
