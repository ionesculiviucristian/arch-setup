#!/bin/bash
set -eu

# [Config] https://github.com/abraunegg/onedrive/blob/master/config

# shellcheck source=../_config.sh
source "./setups/base/_config.sh"

# shellcheck source=../../../scripts/installer.sh
source "./scripts/installer.sh"

if [ ! -f "./mounts.json" ]; then
  info "mounts.json not found, skipping OneDrive mounts"
  exit 0
fi

mkdir -p "${onedrive_dir}"

mkdir -p "${HOME}/OneDrive"

./scripts/update_user_places.sh "${HOME}/OneDrive" "OneDrive"

cp \
  "configs/.config/onedrive/config" \
  "${onedrive_dir}/config"

onedrive_sync_list="${onedrive_dir}/sync_list"
: >"${onedrive_sync_list}"

while read -r entry; do
  src=$(read_mount_field "${entry}" "source" | envsubst)
  dest=$(read_mount_field "${entry}" "destination" | envsubst)
  options=$(read_mount_field "${entry}" "options")

  if [ ! -e "${src}" ]; then
    info "Source ${src} does not exist, skipping"
    continue
  fi

  echo "${dest#"${HOME}/OneDrive/"}" >>"${onedrive_sync_list}"

  mkdir -p "${dest}"
  touch "${dest}/.nosync"

  ./scripts/create_fstab_entry.sh "${src}" "${dest}" "none" "${options}"
done < <(read_mounts "onedrive")

sudo systemctl daemon-reload
sudo mount -a

echo "Y" | onedrive --sync --resync

exit 0
