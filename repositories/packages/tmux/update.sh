#!/bin/bash
set -eu

# @see [plugins](https://github.com/tmux-plugins/tpm/blob/master/docs/managing_plugins_via_cmd_line.md)

tpm_dir="${HOME}/.tmux/plugins/tpm"

git -C "${tpm_dir}" pull -q

"${tpm_dir}/bin/update_plugins" all >/dev/null

exit 0
