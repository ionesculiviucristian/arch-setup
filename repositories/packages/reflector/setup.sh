#!/bin/bash
set -eu

# @see [config](https://xyne.dev/projects/reflector/)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

country=$(env::get "REFLECTOR_COUNTRY")

COUNTRY=${country} envsubst <"${package_dir}/config/reflector.conf.stub" |
  sudo tee "/etc/xdg/reflector/reflector.conf" >/dev/null

sudo systemctl enable --now reflector.timer

exit 0
