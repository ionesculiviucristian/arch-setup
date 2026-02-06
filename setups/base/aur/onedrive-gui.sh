#!/bin/bash
set -eu

# shellcheck source=../_config.sh
source "./setups/base/_config.sh"

mkdir -p "${onedrive_gui_dir}"

cp \
  "configs/.config/onedrive-gui/gui_settings" \
  "${onedrive_gui_dir}/gui_settings"

envsubst <"configs/.config/onedrive-gui/profiles.stub" \
  >"${onedrive_gui_dir}/profiles"

exit 0
