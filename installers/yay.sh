#!/bin/bash
set -eu

git clone --quiet https://aur.archlinux.org/yay.git "${HOME}/.repos/yay"

(
  cd "${HOME}/.repos/yay"
  makepkg -si --needed --noconfirm >/dev/null
)
