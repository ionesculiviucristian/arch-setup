#!/bin/bash
set -eu

yay_dir="${HOME}/.repos/yay"

rm -rf "${yay_dir}"

git clone -q https://aur.archlinux.org/yay.git "${yay_dir}"

(
  cd "${yay_dir}"
  makepkg -si --needed --noconfirm >/dev/null
)
