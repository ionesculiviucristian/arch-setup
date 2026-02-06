#!/bin/bash
set -eu

# shellcheck disable=SC1091
source "./scripts/installer.sh"

# shellcheck source=../../setups/base/_config.sh
source "./setups/base/_config.sh"

email="$1"

if [ -z "${email}" ]; then
  echo "Error: E-mail is required"
  exit 1
fi

# shellcheck disable=SC1091
set -a && source ".env" && set +a

authorized_keys_file="${ssh_dir}/authorized_keys"
onedrive_refresh_token_file="${onedrive_dir}/refresh_token"
ssh_config_file="${ssh_dir}/config"

BW_SESSION=$(bw login "${email}" --method 0 --raw)
export BW_SESSION

info "Importing .env..."
bw get item "Arch setup" |
  jq -r '.notes' >"./.env"

info "Importing mounts..."
bw get item "Arch mounts" |
  jq -r '.notes' >"./mounts.json"

info "Importing GPG keys..."
bw get item "GPG private key" |
  jq -r '.notes' | gpg --import >/dev/null 2>&1

bw get item "GPG public key" |
  jq -r '.notes' | gpg --import >/dev/null 2>&1

info "Importing SSH config..."
mkdir -p "${ssh_dir}"
chmod 700 "${ssh_dir}"

bw get item "Personal SSH key" |
  jq -r '.sshKey.publicKey' >"${authorized_keys_file}"
chmod 600 "${authorized_keys_file}"

bw get item "SSH config" |
  jq -r '.notes' >"${ssh_config_file}"
chmod 600 "${ssh_config_file}"

info "Importing private bash aliases..."
bw get item "Private bash aliases" |
  jq -r '.notes' >"${HOME}/.bash_private_aliases"

info "Importing FileZilla FTP hosts..."
mkdir -p "${filezilla_dir}"
bw get item "FTP hosts" |
  jq -r '.notes' >"${filezilla_dir}/sitemanager.xml"

info "Importing OneDrive refresh token..."
mkdir -p "${onedrive_dir}"
bw get item "OneDrive refresh token" |
  jq -r '.notes' >"${onedrive_refresh_token_file}"
chmod 600 "${onedrive_refresh_token_file}"

info "Login to NordVPN..."
nordvpn_access_token=$(bw get item "NordVPN access token" | jq -r '.notes')
echo "n" | nordvpn login --token "${nordvpn_access_token}" >/dev/null

bw logout

exit 0
