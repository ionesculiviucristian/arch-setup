#!/bin/bash
set -eu

# [shell] https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

"${root_dir}/scripts/update_bashrc.sh" "zoxide" <<'EOF'
eval "$(zoxide init bash)"
EOF

exit 0
