#!/bin/bash
set -eu

# @see [config](https://superfile.dev/configure/superfile-config/)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

superfile_config_dir="${HOME}/.config/superfile"

install -D -m 644 \
  "${package_dir}/config/config.toml" \
  "${superfile_config_dir}/config.toml"

exit 0
