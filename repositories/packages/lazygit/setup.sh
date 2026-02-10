#!/bin/bash
set -eu

# [Default config] https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

lazygit_dir="${HOME}/.config/lazygit"

mkdir -p "${lazygit_dir}"

cp \
  "${root_dir}/repositories/packages/lazygit/config/config.yml" \
  "${lazygit_dir}/config.yml"

"${root_dir}/scripts/update_bashrc.sh" "lazygit" <<'EOF'
export LG_CONFIG_FILE="${HOME}/.config/lazygit/config.yml"
EOF

exit 0
