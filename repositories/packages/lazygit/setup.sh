#!/bin/bash
set -eu

# @see [config](https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

lazygit_config_dir="${HOME}/.config/lazygit"

install -D -m 644 \
  "${package_dir}/config/config.yml" \
  "${lazygit_config_dir}/config.yml"

exit 0
