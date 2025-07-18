#!/bin/bash
set -eu

# https://python-poetry.org/docs/main/#installing-with-the-official-installer

export PATH="${HOME}/.local/bin:${PATH}"

poetry completions bash >> "${HOME}/.bash_completion"

./scripts/update_bashrc.sh 'export PATH="${HOME}/.local/bin:${PATH}"'

exit 0
