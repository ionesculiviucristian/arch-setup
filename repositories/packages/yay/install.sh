#!/bin/bash
set -eu

if command -v yay &>/dev/null; then
  exit 0
fi

yay_dir="${HOME}/.repos/yay"

rm -rf "${yay_dir}"

git clone -q --depth=1 \
  https://aur.archlinux.org/yay.git \
  "${yay_dir}"

(
  cd "${yay_dir}"
  makepkg -si --needed --noconfirm >/dev/null
)

exit 0
