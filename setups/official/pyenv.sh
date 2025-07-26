#!/bin/bash
set -eu

# https://github.com/pyenv/pyenv?tab=readme-ov-file#bash

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

pyenv install --skip-existing 3.10 >/dev/null
pyenv install --skip-existing 3.11 >/dev/null
pyenv install --skip-existing 3.12 >/dev/null
pyenv install --skip-existing 3.13 >/dev/null

./scripts/update_bashrc.sh 'export PYENV_ROOT="$HOME/.pyenv"'
./scripts/update_bashrc.sh '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"'
./scripts/update_bashrc.sh 'eval "$(pyenv init - bash)"'

exit 0
