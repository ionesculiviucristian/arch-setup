#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

"${package_dir}/install-mpv-scripts.sh"

exit 0
