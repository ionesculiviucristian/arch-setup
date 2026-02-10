#!/bin/bash
set -eu

# [config] https://github.com/sharkdp/bat?tab=readme-ov-file#configuration-file

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

bat_dir="${HOME}/.config/bat"

mkdir -p "${bat_dir}"

cp \
  "${root_dir}/repositories/packages/bat/config/config" \
  "${bat_dir}/config"

exit 0
