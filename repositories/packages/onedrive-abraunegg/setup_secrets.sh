#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../scripts/secrets.sh
source "${root_dir}/scripts/secrets.sh"

onedrive_config_dir="${HOME}/.config/onedrive"
onedrive_refresh_token_file="${onedrive_config_dir}/refresh_token"

mkdir -p "${onedrive_config_dir}"
read_secret "OneDrive refresh token" >"${onedrive_refresh_token_file}"
chmod 600 "${onedrive_refresh_token_file}"

exit 0
