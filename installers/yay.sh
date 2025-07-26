#!/bin/bash
set -eu

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

if command -v yay &>/dev/null; then
  info_msg "yay is already installed, skipping"
  exit 0
fi

yay_dir="${HOME}/.repos/yay"

rm -rf "${yay_dir}"

git clone -q https://aur.archlinux.org/yay.git "${yay_dir}"

(
  cd "${yay_dir}"
  makepkg -si --needed --noconfirm >/dev/null
)
