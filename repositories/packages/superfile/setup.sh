#!/bin/bash
set -eu

# [config] https://superfile.dev/configure/superfile-config/

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

superfile_config_dir="${HOME}/.config/superfile"

mkdir -p "${superfile_config_dir}"

cp \
  "${package_dir}/config/config.toml" \
  "${superfile_config_dir}/config.toml"

exit 0
