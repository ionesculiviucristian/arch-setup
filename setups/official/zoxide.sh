#!/bin/bash
set -eu

# https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation

./scripts/update_bashrc.sh << 'EOF'
eval "$(zoxide init bash)"
EOF

exit 0
