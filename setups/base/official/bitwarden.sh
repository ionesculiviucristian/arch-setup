#!/bin/bash
set -eu

# [bashrc] https://bitwarden.com/help/ssh-agent/#configure-bitwarden-ssh-agent

./scripts/update_bashrc.sh "bitwarden" <<'EOF'
# https://bitwarden.com/help/ssh-agent/#configure-bitwarden-ssh-agent
export SSH_AUTH_SOCK="${HOME}/.bitwarden-ssh-agent.sock"
EOF

exit 0
