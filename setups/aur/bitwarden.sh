#!/bin/bash
set -eu

./scripts/update_bashrc.sh 'export SSH_AUTH_SOCK="${HOME}/.bitwarden-ssh-agent.sock"'

exit 0
