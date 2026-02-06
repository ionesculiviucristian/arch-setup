#!/bin/bash
set -eu

# shellcheck source=../../../setups/base/_config.sh
source "./setups/base/_config.sh"

curl -sSL https://raw.githubusercontent.com/Bharath-code/git-scope/main/scripts/install.sh | sh

mkdir -p "${git_scope_dir}"

cp \
  "./configs/.config/git-scope/config.yml" \
  "${git_scope_dir}/config.yml"

exit 0
