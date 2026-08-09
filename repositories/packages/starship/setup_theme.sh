#!/bin/bash
set -eu

# [theme] https://github.com/catppuccin/starship?tab=readme-ov-file#usage

if [ $# -ne 2 ]; then
  echo "Usage: $0 <flavour> <accent>"
  exit 1
fi

flavour="$1"
# accent="$2"

starship_config_dir="${HOME}/.config/starship"
starship_theme="${flavour}"

mkdir -p "${starship_config_dir}/themes"

wget -qO \
  "${starship_config_dir}/themes/${starship_theme}.toml" \
  "https://raw.githubusercontent.com/catppuccin/starship/refs/heads/main/themes/${starship_theme}.toml"

cat \
  "${starship_config_dir}/config.toml" \
  "${starship_config_dir}/themes/${starship_theme}.toml" \
  >"${HOME}/.config/.starship.toml"

sed -i \
  "s/^#\? *palette = .*/palette = \"catppuccin_${flavour}\"/" \
  "${starship_config_dir}/config.toml"

exit 0
