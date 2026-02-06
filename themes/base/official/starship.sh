#!/bin/bash
set -eu

# shellcheck source=../../../setups/base/_config.sh
source "./setups/base/_config.sh"

install_starship_theme() {
  mkdir -p "${starship_dir}/themes"

  wget -qO \
    "${starship_dir}/themes/${starship_theme}.conf" \
    "https://raw.githubusercontent.com/catppuccin/starship/refs/heads/main/themes/${starship_theme}.toml"

  cat \
    "${starship_dir}/config.toml" \
    "${starship_dir}/themes/${starship_theme}.conf" \
    >"${HOME}/.config/.starship.toml"
}
