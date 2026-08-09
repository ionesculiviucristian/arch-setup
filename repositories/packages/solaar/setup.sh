#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

solaar_config_dir="${HOME}/.config/solaar"

install -D -m 644 \
  "${package_dir}/config/config.yaml" \
  "${solaar_config_dir}/config.yaml"

exit 0
