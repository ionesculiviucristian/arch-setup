#!/bin/bash
set -eu

# @see [config](https://github.com/abraunegg/onedrive/blob/master/config)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

if [ -z "$(file::find "mounts.json")" ]; then
  log::info "mounts.json not found, skipping OneDrive mounts"
  exit 0
fi

onedrive_config_dir="${HOME}/.config/onedrive"

mkdir -p "${HOME}/OneDrive"

kde::add_user_place "${HOME}/OneDrive" "OneDrive"

onedrive_config_file="${onedrive_config_dir}/config"
onedrive_sync_list="${onedrive_config_dir}/sync_list"

sync_list_draft=$(mktemp)
trap 'rm -f "${sync_list_draft}"' EXIT

needs_resync=false

if [ ! -f "${onedrive_config_dir}/items.sqlite3" ]; then
  needs_resync=true
fi

if ! cmp -s "${package_dir}/config/config" "${onedrive_config_file}"; then
  needs_resync=true
fi

install -D -m 644 \
  "${package_dir}/config/config" \
  "${onedrive_config_file}"

while read -r entry; do
  src=$(mounts::field "${entry}" "source" | envsubst)
  dest=$(mounts::field "${entry}" "destination" | envsubst)
  options=$(mounts::field "${entry}" "options")

  if [ ! -e "${src}" ]; then
    log::info "Source ${src} does not exist, skipping"
    continue
  fi

  echo "${dest#"${HOME}/OneDrive/"}" >>"${sync_list_draft}"

  mkdir -p "${dest}"

  if ! mountpoint -q "${dest}"; then
    touch "${dest}/.nosync"
  fi

  fstab::add_entry \
    "${src}" \
    "${dest}" \
    "none" \
    "${options}"
done < <(mounts::list "onedrive")

if [ ! -s "${sync_list_draft}" ]; then
  log::info "No OneDrive source is available, keeping the current sync_list"
  exit 0
fi

if ! cmp -s "${sync_list_draft}" "${onedrive_sync_list}"; then
  needs_resync=true
  install -D -m 644 \
    "${sync_list_draft}" \
    "${onedrive_sync_list}"
fi

sudo systemctl daemon-reload
sudo mount -a

if [ "${needs_resync}" = "true" ]; then
  if [ -s "${onedrive_config_dir}/refresh_token" ]; then
    echo "Y" | onedrive --sync --resync
  else
    log::info "  Authorise OneDrive, then run 'onedrive --sync --resync'"
  fi
fi

exit 0
