#!/bin/bash
# shellcheck disable=SC1091
# shellcheck disable=SC2155
set -eu

# https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install --no-progress 18
nvm install --no-progress 20
nvm install --no-progress 22
nvm install --no-progress 24

nvm use 24

nvm install-latest-npm

exit 0
