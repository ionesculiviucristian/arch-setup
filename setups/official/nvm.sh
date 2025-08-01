#!/bin/bash
set -eu

# shellcheck disable=SC1091
source /usr/share/nvm/init-nvm.sh

nvm install --latest-npm 18 >/dev/null
nvm install --latest-npm 20 >/dev/null
nvm install --latest-npm 22 >/dev/null
nvm install --latest-npm 24 >/dev/null

nvm use 24 >/dev/null

./scripts/update_bashrc.sh << 'EOF'
source /usr/share/nvm/init-nvm.sh
EOF

exit 0
