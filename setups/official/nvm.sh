#!/bin/bash
set -eu

# shellcheck disable=SC1091
source /usr/share/nvm/init-nvm.sh

nvm install --no-progress --latest-npm 18
nvm install --no-progress --latest-npm 20
nvm install --no-progress --latest-npm 22
nvm install --no-progress --latest-npm 24

nvm use 24 >/dev/null

./scripts/update_bashrc.sh << 'EOF'
source /usr/share/nvm/init-nvm.sh
EOF

exit 0
