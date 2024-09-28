#!/bin/bash
set -eu

# [bashrc] https://python-poetry.org/docs/main/#installing-with-the-official-installer

export PATH="${HOME}/.local/bin:${PATH}"

poetry completions bash >> "${HOME}/.bash_completion"

./scripts/update_bashrc.sh << 'EOF'
export PATH="${HOME}/.local/bin:${PATH}"
EOF

exit 0
