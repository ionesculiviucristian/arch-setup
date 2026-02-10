#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

obs_dir="${HOME}/.config/obs-studio"

mkdir -p "${obs_dir}"

cp \
  "${root_dir}/repositories/packages/obs-studio/config/user.ini" \
  "${obs_dir}/user.ini"

exit 0
