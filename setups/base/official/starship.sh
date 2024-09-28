#!/bin/bash
set -eu

# [bashrc] https://github.com/starship/starship?tab=readme-ov-file#step-2-set-up-your-shell-to-use-starship
# [Config] https://starship.rs/config/
# [Theme] https://github.com/catppuccin/starship

starship_dir="${HOME}/.config/starship"
starship_theme="mocha"

mkdir -p "${starship_dir}/themes"

wget -qO \
  "${starship_dir}/themes/${starship_theme}.conf" \
  https://raw.githubusercontent.com/catppuccin/starship/refs/heads/main/themes/${starship_theme}.toml

cp \
  "./configs/.config/starship/config.toml" \
  "${starship_dir}/config.toml"

cat \
  "${starship_dir}/config.toml" \
  "${starship_dir}/themes/${starship_theme}.conf" \
  > "${HOME}/.config/.starship.toml"

./scripts/update_bashrc.sh << 'EOF'
# https://github.com/starship/starship?tab=readme-ov-file#step-2-set-up-your-shell-to-use-starship
eval "$(starship init bash)"
EOF

exit 0
