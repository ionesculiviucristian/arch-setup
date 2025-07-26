#!/bin/bash
# shellcheck disable=SC1091
# shellcheck disable=SC2155
set -eu

source "/usr/share/nvm/init-nvm.sh"

nvm ls 18 | grep -q 'v18' || nvm install --latest-npm 18 2>&1 | tee "./install.log" >/dev/null
nvm ls 20 | grep -q 'v20' || nvm install --latest-npm 20 2>&1 | tee "./install.log" >/dev/null
nvm ls 22 | grep -q 'v22' || nvm install --latest-npm 22 2>&1 | tee "./install.log" >/dev/null
nvm ls 24 | grep -q 'v24' || nvm install --latest-npm 24 2>&1 | tee "./install.log" >/dev/null

nvm use 24 2>&1 | tee "./install.log" >/dev/null

./scripts/update_bashrc.sh "source /usr/share/nvm/init-nvm.sh"

exit 0
