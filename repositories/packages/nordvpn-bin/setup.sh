#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

docker_subnet="172.16.0.0/12"

sudo usermod -aG nordvpn "${USER}"

sudo systemctl enable --now nordvpnd.service

sudo timeout 30 bash -c 'until [ -S /run/nordvpn/nordvpnd.sock ]; do sleep 1; done'

sudo nordvpn set protocol nordlynx >/dev/null

if ! sudo nordvpn settings | grep -qF "${docker_subnet}"; then
  sudo nordvpn allowlist add subnet "${docker_subnet}" >/dev/null ||
    log::info "  Log in to NordVPN and run setup again to allowlist ${docker_subnet}"
fi

exit 0
