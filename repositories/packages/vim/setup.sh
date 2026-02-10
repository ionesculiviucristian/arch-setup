#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

cp "${root_dir}/repositories/packages/vim/config/.vimrc" "${HOME}/.vimrc"

exit 0
