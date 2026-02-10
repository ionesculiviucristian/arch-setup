#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

# shellcheck source=../../../scripts/bitwarden.sh
source "${root_dir}/scripts/bitwarden.sh"

nordvpn_access_token=$(read_bitwarden_entry "NordVPN access token")
echo "n" | nordvpn login --token "${nordvpn_access_token}" >/dev/null

exit 0
