#!/bin/bash
set -eu

# shellcheck source=../../../setups/base/_config.sh
source "./setups/base/_config.sh"

# shellcheck disable=SC1091
source "./scripts/installer.sh"

install_grub_theme() {
  rm -rf "${catppuccin_grub_dir}"
  sudo rm -rf "${grub_themes_dir}/${grub_theme}"

  git clone -q --depth=1 \
    https://github.com/catppuccin/grub.git \
    "${catppuccin_grub_dir}"

  sudo cp -r \
    "${catppuccin_grub_dir}/src/${grub_theme}" \
    "${grub_themes_dir}/${grub_theme}"
}
