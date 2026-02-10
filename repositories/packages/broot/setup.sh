#!/bin/bash
set -eu

# [shell] https://dystroy.org/broot/install-br/#automatic-shell-function-installation

broot_dir="${HOME}/.config/broot"

mkdir -p "${broot_dir}"

broot --install >/dev/null
broot --write-default-conf "${broot_dir}"

sed -i \
  's/enable_kitty_keyboard: false/enable_kitty_keyboard: true/' \
  "${broot_dir}/conf.hjson"

exit 0
