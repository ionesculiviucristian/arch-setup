#!/bin/bash
set -eu

./scripts/update_bashrc.sh << 'EOF'
# Initialize direnv
# https://github.com/direnv/direnv/blob/master/docs/hook.md#bash
eval "$(direnv hook bash)"
EOF

exit 0
