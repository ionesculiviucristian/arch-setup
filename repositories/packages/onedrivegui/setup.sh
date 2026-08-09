#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

onedrive_gui_config_dir="${HOME}/.config/onedrive-gui"

mkdir -p "${onedrive_gui_config_dir}"

cp \
  "${package_dir}/config/gui_settings" \
  "${onedrive_gui_config_dir}/gui_settings"

envsubst <"${package_dir}/config/profiles.stub" \
  >"${onedrive_gui_config_dir}/profiles"

exit 0
