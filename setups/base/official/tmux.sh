#!/bin/bash
set -eu

# shellcheck source=../_config.sh
source "./setups/base/_config.sh"

rm -rf "${tmux_plugins_dir}"

mkdir -p "${tmux_plugins_dir}"

git clone --depth=1 \
  https://github.com/tmux-plugins/tpm \
  "${tmux_plugins_dir}/tpm"

cp "./configs/.tmux.conf" "${HOME}/.tmux.conf"

"${HOME}/.tmux/plugins/tpm/bin/install_plugins"

exit 0
