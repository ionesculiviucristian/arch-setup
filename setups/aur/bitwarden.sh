#!/bin/bash
set -eu

# https://bitwarden.com/help/ssh-agent/#configure-bitwarden-ssh-agent

./scripts/update_bashrc.sh <<'EOF'
# Set Bitwarden as a SSH Agent
export SSH_AUTH_SOCK="${HOME}/.bitwarden-ssh-agent.sock"
EOF

exit 0
