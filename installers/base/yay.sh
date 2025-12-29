#!/bin/bash
set -eu

# shellcheck source=../../setups/base/_config.sh
source "./setups/base/_config.sh"

if command -v yay &>/dev/null; then
  exit 0
fi

rm -rf "${yay_dir}"

git clone -q https://aur.archlinux.org/yay.git "${yay_dir}"

(
  cd "${yay_dir}"
  makepkg -si --needed --noconfirm >/dev/null
)

exit 0
