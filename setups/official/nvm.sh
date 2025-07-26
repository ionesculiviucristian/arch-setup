#!/bin/bash
# shellcheck disable=SC1091
# shellcheck disable=SC2155
set -eu

source /usr/share/nvm/init-nvm.sh

nvm install --no-progress 18
nvm install --no-progress 20
nvm install --no-progress 22
nvm install --no-progress 24

nvm use 24

nvm install-latest-npm

./scripts/update_bashrc.sh "source /usr/share/nvm/init-nvm.sh"

exit 0
