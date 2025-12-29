#!/bin/bash
set -eu

# shellcheck source=../../../setups/base/_config.sh
source "./setups/base/_config.sh"

install_lazygit_theme() {
  mkdir -p "${lazygit_dir}"

  wget -qO \
    "${lazygit_dir}/mocha-mauve.yml" \
    "https://raw.githubusercontent.com/catppuccin/lazygit/refs/heads/main/themes-mergable/mocha/mauve.yml"
}
