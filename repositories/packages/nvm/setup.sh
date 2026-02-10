#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

source /usr/share/nvm/init-nvm.sh >/dev/null

# nvm install --no-progress --latest-npm 18 >/dev/null
# nvm install --no-progress --latest-npm 20 >/dev/null
# nvm install --no-progress --latest-npm 22 >/dev/null
nvm install --no-progress --latest-npm 24 >/dev/null

nvm use 24 >/dev/null

npm install -g npm-check-updates

"${root_dir}/scripts/update_bashrc.sh" "nvm" <<'EOF'
source /usr/share/nvm/init-nvm.sh
EOF

exit 0
