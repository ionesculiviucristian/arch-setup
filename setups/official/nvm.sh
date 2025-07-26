#!/bin/bash
# shellcheck disable=SC1091
# shellcheck disable=SC2155
set -eu

source "/usr/share/nvm/init-nvm.sh"

nvm install --latest-npm 18 2>&1 | tee -a "./install.log" >/dev/null
nvm install --latest-npm 20 2>&1 | tee -a "./install.log" >/dev/null
nvm install --latest-npm 22 2>&1 | tee -a "./install.log" >/dev/null
nvm install --latest-npm 24 2>&1 | tee -a "./install.log" >/dev/null

nvm use 24 2>&1 | tee -a "./install.log" >/dev/null

./scripts/update_bashrc.sh "source /usr/share/nvm/init-nvm.sh"

exit 0
