#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

device=$(yq -r '.device' "${package_dir}/config/fans.yml")

sudo install -D -m 755 \
  "${package_dir}/liquidctl-fans.sh" \
  "/usr/local/bin/liquidctl-fans"

sudo install -D -m 644 \
  "${package_dir}/config/fans.yml" \
  "/etc/liquidctl-fans.yml"

sudo install -D -m 644 \
  "${package_dir}/config/liquidctl-fans.service" \
  "/etc/systemd/system/liquidctl-fans.service"

sudo systemctl daemon-reload
sudo systemctl enable liquidctl-fans.service

if liquidctl list | grep -qF "${device}"; then
  sudo systemctl restart liquidctl-fans.service
else
  log::info "  ${device} is not connected, the fan speeds apply on the next boot"
fi

exit 0
