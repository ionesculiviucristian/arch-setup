#!/bin/bash
set -eu

# [bashrc] https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation

./scripts/update_bashrc.sh "zoxide" << 'EOF'
# https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation
eval "$(zoxide init bash)"
EOF

exit 0
