#!/bin/bash
set -eu

baloofilerc_file="${HOME}/.config/baloofilerc"
baloo_index_dir="${HOME}/.local/share/baloo"

kwriteconfig6 \
  --file "${baloofilerc_file}" \
  --group "Basic Settings" \
  --key "Indexing-Enabled" \
  --type "bool" \
  false

if systemctl --user --quiet is-active "kde-baloo.service"; then
  systemctl --user stop "kde-baloo.service"
fi

rm -rf "${baloo_index_dir}"

exit 0
