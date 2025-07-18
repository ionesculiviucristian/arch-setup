#!/bin/bash
set -eu

# https://bitwarden.com/help/ssh-agent/#configure-bitwarden-ssh-agent

./scripts/update_bashrc.sh 'export SSH_AUTH_SOCK="${HOME}/.bitwarden-ssh-agent.sock"'

exit 0
