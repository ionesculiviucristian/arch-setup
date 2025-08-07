#!/bin/bash
set -eu

# shellcheck disable=SC1091
set -a && source ".env" && set +a

filezilla_dir="${HOME}/.config/filezilla"

mkdir -p "${filezilla_dir}"

BW_SESSION=$(bw login "${BITWARDEN_EMAIL}" --method 0 --raw)
export BW_SESSION

bw get attachment "AdGuardHome.yaml" --itemid "AdGuard Home" | \
  sudo tee "/var/lib/adguardhome/AdGuardHome.yaml" > /dev/null

bw get item "Arch setup" | \
  jq -r '.notes' > "./.env"

bw get item "Private bash aliases" | \
  jq -r '.notes' > "${HOME}/.bash_private_aliases"

bw get item "FTP hosts" | \
  jq -r '.notes' > "${filezilla_dir}/sitemanager.xml"

bw get item "GPG private key" | \
  jq -r '.notes' | gpg --import

bw get item "GPG public key" | \
  jq -r '.notes' | gpg --import

bw logout

sudo systemctl restart adguardhome

exit 0
