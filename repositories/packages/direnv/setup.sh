#!/bin/bash
set -eu

# [shell] https://github.com/direnv/direnv/blob/master/docs/hook.md#bash

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

"${root_dir}/scripts/update_bashrc.sh" "direnv" <<'EOF'
eval "$(direnv hook bash)"
EOF

exit 0
