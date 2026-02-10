#!/bin/bash
set -eu

# [shell] https://bitwarden.com/help/ssh-agent/#configure-bitwarden-ssh-agent

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

"${root_dir}/scripts/update_bashrc.sh" "bitwarden" <<'EOF'
export SSH_AUTH_SOCK="${HOME}/.bitwarden-ssh-agent.sock"
EOF

exit 0
