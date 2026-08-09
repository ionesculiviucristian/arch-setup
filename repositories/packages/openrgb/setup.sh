#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

aliases_dir="${HOME}/.bash_aliases.d"
lights_config_dir="${HOME}/.config/lights"

install -D -m 755 \
  "${package_dir}/lights.sh" \
  "${aliases_dir}/lights.sh"

install -D -m 644 \
  "${package_dir}/config/OpenRGB.json" \
  "${lights_config_dir}/OpenRGB.json"

install -D -m 644 \
  "${package_dir}/config/lights.yml" \
  "${lights_config_dir}/lights.yml"

install -D -m 644 \
  "${package_dir}/config/lights-restore.service" \
  "${HOME}/.config/systemd/user/lights-restore.service"

systemctl --user daemon-reload
systemctl --user enable --now lights-restore.service

exit 0
