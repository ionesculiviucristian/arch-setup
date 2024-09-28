#!/bin/bash
set -eu

email="$1"

if [ -z "${email}" ]; then
  echo "Error: E-mail is required"
  exit 1
fi

# shellcheck disable=SC1091
set -a && source ".env" && set +a

adguardhome_dir="/var/lib/adguardhome"
filezilla_dir="${HOME}/.config/filezilla"
ssh_dir="${HOME}/.ssh"
authorized_keys_file="${ssh_dir}/authorized_keys"

BW_SESSION=$(bw login "${email}" --method 0 --raw)
export BW_SESSION

bw get item "Arch setup" | \
  jq -r '.notes' > "./.env"

bw get item "Private bash aliases" | \
  jq -r '.notes' > "${HOME}/.bash_private_aliases"

bw get item "GPG private key" | \
  jq -r '.notes' | gpg --import

bw get item "GPG public key" | \
  jq -r '.notes' | gpg --import

mkdir -p "${ssh_dir}"
chmod 700 "${ssh_dir}"
bw get item "Personal SSH key" | \
  jq -r '.sshKey.publicKey' > "${authorized_keys_file}"
chmod 600 "${authorized_keys_file}"

sudo mkdir -p "${adguardhome_dir}"
bw get attachment "AdGuardHome.yaml" --itemid "AdGuard Home" --raw | \
  sudo tee "/var/lib/adguardhome/AdGuardHome.yaml" >/dev/null
sudo systemctl restart adguardhome

mkdir -p "${filezilla_dir}"
bw get item "FTP hosts" | \
  jq -r '.notes' > "${filezilla_dir}/sitemanager.xml"

bw logout

exit 0
