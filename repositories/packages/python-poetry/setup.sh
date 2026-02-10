#!/bin/bash
set -eu

# [shell] https://python-poetry.org/docs/main/#installing-with-the-official-installer

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

export PATH="${HOME}/.local/bin:${PATH}"

poetry completions bash >>"${HOME}/.bash_completion"

"${root_dir}/scripts/update_bashrc.sh" "poetry" <<'EOF'
export PATH="${HOME}/.local/bin:${PATH}"
EOF

exit 0
