#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

# shellcheck source=../../../scripts/bitwarden.sh
source "${root_dir}/scripts/bitwarden.sh"

onedrive_dir="${HOME}/.config/onedrive"
onedrive_refresh_token_file="${onedrive_dir}/refresh_token"

mkdir -p "${onedrive_dir}"
read_bitwarden_entry "OneDrive refresh token" >"${onedrive_refresh_token_file}"
chmod 600 "${onedrive_refresh_token_file}"

exit 0
