#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

onedrive_gui_dir="${HOME}/.config/onedrive-gui"

mkdir -p "${onedrive_gui_dir}"

cp \
  "${root_dir}/repositories/packages/onedrivegui/config/gui_settings" \
  "${onedrive_gui_dir}/gui_settings"

envsubst <"${root_dir}/repositories/packages/onedrivegui/config/profiles.stub" \
  >"${onedrive_gui_dir}/profiles"

exit 0
