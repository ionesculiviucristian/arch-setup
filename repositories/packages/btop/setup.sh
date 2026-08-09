#!/bin/bash
set -eu

# [config] https://github.com/aristocratos/btop?tab=readme-ov-file#configurability

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

btop_config_dir="${HOME}/.config/btop"

mkdir -p "${btop_config_dir}"

cp \
  "${package_dir}/config/btop.conf" \
  "${btop_config_dir}/btop.conf"

exit 0
