#!/bin/bash
set -eu

nvm install --latest-npm 18 >/dev/null
nvm install --latest-npm 20 >/dev/null
nvm install --latest-npm 22 >/dev/null
nvm install --latest-npm 24 >/dev/null

nvm use 24 >/dev/null

./scripts/update_bashrc.sh << 'EOF'
source /usr/share/nvm/init-nvm.sh
EOF

exit 0
