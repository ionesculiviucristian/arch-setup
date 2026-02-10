#!/bin/bash
set -eu

# [shell] https://github.com/pyenv/pyenv?tab=readme-ov-file#bash

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

# pyenv install --skip-existing 3.10
# pyenv install --skip-existing 3.11
# pyenv install --skip-existing 3.12
pyenv install --skip-existing 3.13

"${root_dir}/scripts/update_bashrc.sh" "pyenv" <<'EOF'
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
EOF

exit 0
