#!/bin/bash
set -eu

# [config] https://xyne.dev/projects/reflector/

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../.env.example
set -a && source "${root_dir}/.env" && set +a

export COUNTRY="${REFLECTOR_COUNTRY}"

envsubst <"${package_dir}/config/reflector.conf.stub" |
  sudo tee "/etc/xdg/reflector/reflector.conf" >/dev/null

sudo systemctl enable --now reflector.timer

exit 0
