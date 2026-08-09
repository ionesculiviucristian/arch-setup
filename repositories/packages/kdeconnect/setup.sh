#!/bin/bash
set -eu

# [config] https://userbase.kde.org/KDEConnect

kdeconnect_config_dir="${HOME}/.config/kdeconnect"
incoming_dir="${HOME}/Documents"

mkdir -p "${kdeconnect_config_dir}" "${incoming_dir}"

# The incoming folder is stored per paired device, so rerun this after pairing a new phone.
if [ -f "${kdeconnect_config_dir}/trusted_devices" ]; then
  grep -oP '^\[\K[^]]+' "${kdeconnect_config_dir}/trusted_devices" | while read -r device_id; do
    share_dir="${kdeconnect_config_dir}/${device_id}/kdeconnect_share"
    mkdir -p "${share_dir}"

    kwriteconfig6 \
      --file "${share_dir}/config" \
      --group "General" \
      --key "incoming_path" \
      "${incoming_dir}"
  done
fi

exit 0
