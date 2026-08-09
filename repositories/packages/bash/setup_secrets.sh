#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../scripts/secrets.sh
source "${root_dir}/scripts/secrets.sh"

read_secret "Private bash aliases" >"${HOME}/.bash_private_aliases"

exit 0
