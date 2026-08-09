#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

cp "${package_dir}/config/.vimrc" "${HOME}/.vimrc"

exit 0
