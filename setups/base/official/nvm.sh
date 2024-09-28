#!/bin/bash
set -eu

# shellcheck disable=SC1091
source /usr/share/nvm/init-nvm.sh >/dev/null

# nvm install --no-progress --latest-npm 18 >/dev/null
# nvm install --no-progress --latest-npm 20 >/dev/null
# nvm install --no-progress --latest-npm 22 >/dev/null
nvm install --no-progress --latest-npm 24 >/dev/null

nvm use 24 >/dev/null

npm install -g npm-check-updates

./scripts/update_bashrc.sh << 'EOF'
source /usr/share/nvm/init-nvm.sh
EOF

exit 0
