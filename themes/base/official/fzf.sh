#!/bin/bash
set -eu

# shellcheck source=../../../setups/base/_config.sh
source "./setups/base/_config.sh"

install_fzf_theme() {
  rm -rf "${catppuccin_fzf_dir}"
  git clone -q https://github.com/catppuccin/fzf.git "${catppuccin_fzf_dir}"
}
