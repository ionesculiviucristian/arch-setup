#!/bin/bash
set -eu

# [config] https://github.com/aristocratos/btop?tab=readme-ov-file#configurability

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

btop_dir="${HOME}/.config/btop"

mkdir -p "${btop_dir}"

cp \
  "${root_dir}/repositories/packages/btop/config/btop.conf" \
  "${btop_dir}/btop.conf"

exit 0
