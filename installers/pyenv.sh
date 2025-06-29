#!/bin/bash
set -eu

sudo pacman -Syu --needed --noconfirm \
    openssl \
    tk \
    xz \
    zlib

curl https://pyenv.run | bash

# shellcheck disable=SC2129
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> "${HOME}/.bashrc"
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> "${HOME}/.bashrc"
echo 'eval "$(pyenv init - bash)"' >> "${HOME}/.bashrc"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

pyenv install 3.10
pyenv install 3.11
pyenv install 3.12
pyenv install 3.13
