#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

tmux_plugins_dir="${HOME}/.tmux/plugins"

rm -rf "${tmux_plugins_dir}"

mkdir -p "${tmux_plugins_dir}"

git clone --depth=1 \
  https://github.com/tmux-plugins/tpm \
  "${tmux_plugins_dir}/tpm"

cp "${root_dir}/repositories/packages/tmux/config/.tmux.conf" "${HOME}/.tmux.conf"

"${HOME}/.tmux/plugins/tpm/bin/install_plugins"

exit 0
