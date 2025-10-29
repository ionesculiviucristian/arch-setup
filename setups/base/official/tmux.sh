#!/bin/bash
set -eu

tmux_plugins_dir="${HOME}/.tmux/plugins"

rm -rf "${tmux_plugins_dir}"

mkdir -p "${tmux_plugins_dir}"

git clone https://github.com/tmux-plugins/tpm "${tmux_plugins_dir}/tpm"

cp "./configs/.tmux.conf" "${HOME}/.tmux.conf"

"${HOME}/.tmux/plugins/tpm/bin/install_plugins"

exit 0
