#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

tmux_plugins_dir="${HOME}/.tmux/plugins"
tpm_dir="${tmux_plugins_dir}/tpm"

mkdir -p "${tmux_plugins_dir}"

if [ ! -d "${tpm_dir}" ]; then
  git clone -q --depth=1 \
    https://github.com/tmux-plugins/tpm \
    "${tpm_dir}"
fi

install -D -m 644 \
  "${package_dir}/config/.tmux.conf" \
  "${HOME}/.tmux.conf"

"${tpm_dir}/bin/install_plugins"

exit 0
