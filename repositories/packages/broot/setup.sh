#!/bin/bash
set -eu

# [shell] https://dystroy.org/broot/install-br/#automatic-shell-function-installation

broot_config_dir="${HOME}/.config/broot"

mkdir -p "${broot_config_dir}"

broot --install >/dev/null
broot --write-default-conf "${broot_config_dir}"

sed -i \
  -e 's/^#\? *default_flags:.*/default_flags: "gh"/' \
  -e 's/^#\? *icon_theme:.*/icon_theme: nerdfont/' \
  -e 's/^#\? *quit_on_last_cancel:.*/quit_on_last_cancel: true/' \
  "${broot_config_dir}/conf.hjson"

exit 0
