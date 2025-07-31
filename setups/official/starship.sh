#!/bin/bash
set -eu

# https://github.com/starship/starship?tab=readme-ov-file#step-2-set-up-your-shell-to-use-starship
# https://starship.rs/config/
# https://github.com/catppuccin/starship

starship_dir="${HOME}/.config/starship"

mkdir -p "${starship_dir}/themes"

cp \
  "./configs/.config/starship/config.toml" \
  "${starship_dir}/config.toml"

wget -qO \
  "${starship_dir}/themes/mocha.conf" \
  https://raw.githubusercontent.com/catppuccin/starship/refs/heads/main/themes/mocha.toml

cat \
  "${starship_dir}/config.toml" \
  "${starship_dir}/themes/mocha.conf" \
  > "${HOME}/.config/.starship.toml"

./scripts/update_bashrc.sh << 'EOF'
eval "$(starship init bash)"
EOF

exit 0
