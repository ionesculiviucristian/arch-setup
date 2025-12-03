#!/bin/bash
set -eu

# https://github.com/direnv/direnv/blob/master/docs/hook.md#bash

./scripts/update_bashrc.sh "direnv" << 'EOF'
# https://github.com/direnv/direnv/blob/master/docs/hook.md#bash
eval "$(direnv hook bash)"
EOF

exit 0
