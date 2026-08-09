#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../scripts/secrets.sh
source "${root_dir}/scripts/secrets.sh"

nordvpn_access_token=$(read_secret"NordVPN access token")
echo "n" | nordvpn login --token "${nordvpn_access_token}" >/dev/null

exit 0
