#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../scripts/secrets.sh
source "${root_dir}/scripts/secrets.sh"

ssh_dir="${HOME}/.ssh"
ssh_authorized_keys_file="${ssh_dir}/authorized_keys"
ssh_config_file="${ssh_dir}/config"

mkdir -p "${ssh_dir}"
chmod 700 "${ssh_dir}"

read_secret "Personal SSH key" "ssh_public_key" >"${ssh_authorized_keys_file}"
chmod 600 "${ssh_authorized_keys_file}"

read_secret "SSH config" >"${ssh_config_file}"
chmod 600 "${ssh_config_file}"

exit 0
