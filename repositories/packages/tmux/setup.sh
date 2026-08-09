#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

tmux_plugins_dir="${HOME}/.tmux/plugins"

rm -rf "${tmux_plugins_dir}"

mkdir -p "${tmux_plugins_dir}"

git clone --depth=1 \
  https://github.com/tmux-plugins/tpm \
  "${tmux_plugins_dir}/tpm"

cp "${package_dir}/config/.tmux.conf" "${HOME}/.tmux.conf"

"${HOME}/.tmux/plugins/tpm/bin/install_plugins"

exit 0
