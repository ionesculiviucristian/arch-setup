#!/bin/bash
set -eu

# [config] https://superfile.dev/configure/superfile-config/

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

superfile_dir="${HOME}/.config/superfile"

mkdir -p "${superfile_dir}"

cp \
  "${root_dir}/repositories/packages/superfile/config/config.toml" \
  "${superfile_dir}/config.toml"

exit 0
