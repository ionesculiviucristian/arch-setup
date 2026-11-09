#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

"${package_dir}/install-go-tools.sh"

exit 0
