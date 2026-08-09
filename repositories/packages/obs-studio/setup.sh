#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

obs_config_dir="${HOME}/.config/obs-studio"

install -D -m 644 \
  "${package_dir}/config/user.ini" \
  "${obs_config_dir}/user.ini"

exit 0
