#!/bin/bash
set -eu

./scripts/update_bashrc.sh 'export PYENV_ROOT="$HOME/.pyenv"'
./scripts/update_bashrc.sh '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"'
./scripts/update_bashrc.sh 'eval "$(pyenv init - bash)"'

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

pyenv install 3.10
pyenv install 3.11
pyenv install 3.12
pyenv install 3.13

exit 0
