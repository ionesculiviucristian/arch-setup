#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

source /usr/share/nvm/init-nvm.sh >/dev/null

# nvm install --no-progress --latest-npm 18 >/dev/null
# nvm install --no-progress --latest-npm 20 >/dev/null
# nvm install --no-progress --latest-npm 22 >/dev/null
nvm install --no-progress --latest-npm 24 >/dev/null

nvm use 24 >/dev/null

npm install -g npm-check-updates

"${root_dir}/scripts/setup_shell.sh" \
  --package "nvm" \
  --priority "20" \
  "${package_dir}/bashrc.sh"

exit 0
