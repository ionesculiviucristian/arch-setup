#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

onedrive_gui_config_dir="${HOME}/.config/onedrive-gui"
autostart_dir="${HOME}/.config/autostart"

install -D -m 644 \
  "${package_dir}/config/gui_settings" \
  "${onedrive_gui_config_dir}/gui_settings"

envsubst <"${package_dir}/config/profiles.stub" \
  >"${onedrive_gui_config_dir}/profiles"

install -D -m 644 \
  "/usr/share/applications/onedrivegui.desktop" \
  "${autostart_dir}/OneDriveGUI.desktop"

exit 0
