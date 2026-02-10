#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

# shellcheck source=../../../scripts/bitwarden.sh
source "${root_dir}/scripts/bitwarden.sh"

ssh_dir="${HOME}/.ssh"
ssh_authorized_keys_file="${ssh_dir}/authorized_keys"
ssh_config_file="${ssh_dir}/config"

mkdir -p "${ssh_dir}"
chmod 700 "${ssh_dir}"

read_bitwarden_entry "Personal SSH key" ".sshKey.publicKey" >"${ssh_authorized_keys_file}"
chmod 600 "${ssh_authorized_keys_file}"

read_bitwarden_entry "SSH config" >"${ssh_config_file}"
chmod 600 "${ssh_config_file}"

exit 0
