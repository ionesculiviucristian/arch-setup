#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# shellcheck source=../../scripts/installer.sh
source "${root_dir}/scripts/installer.sh"

# shellcheck source=../../scripts/secrets.sh
source "${root_dir}/scripts/secrets.sh"

email="${1:-}"

if [ -z "${email}" ]; then
  echo "Error: E-mail is required"
  exit 1
fi

login_secrets "${email}"

info "Importing .env..."
read_secret "Arch setup" >"${root_dir}/.env"

info "Importing mounts..."
read_secret "Arch mounts" >"${root_dir}/mounts.json"

info "Importing GPG keys..."
read_secret "GPG private key" | gpg --import >/dev/null 2>&1
read_secret "GPG public key" | gpg --import >/dev/null 2>&1

info "Importing SSH config..."
"${root_dir}/repositories/packages/openssh/setup_secrets.sh"

info "Importing private bash aliases..."
"${root_dir}/repositories/packages/bash/setup_secrets.sh"

info "Importing FileZilla FTP hosts..."
"${root_dir}/repositories/packages/filezilla/setup_secrets.sh"

info "Importing OneDrive refresh token..."
"${root_dir}/repositories/packages/onedrive-abraunegg/setup_secrets.sh"

info "Login to NordVPN..."
"${root_dir}/repositories/packages/nordvpn-bin/setup_secrets.sh"

logout_secrets

exit 0
