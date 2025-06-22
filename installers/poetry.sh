#!/bin/bash
set -eu

wget -qO- https://install.python-poetry.org | python3 -

echo 'export PATH="${HOME}/.local/bin:${PATH}"' >> "${HOME}/.bashrc"
