#!/bin/bash
set -eu

yay_dir="${HOME}/.repos/yay"

git clone -q https://aur.archlinux.org/yay.git "${yay_dir}"

(
  cd "${yay_dir}"
  makepkg -si --needed --noconfirm >/dev/null
)
