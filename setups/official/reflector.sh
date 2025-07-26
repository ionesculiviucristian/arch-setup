#!/bin/bash
# shellcheck disable=SC1091
set -eu

# https://xyne.dev/projects/reflector/

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

set -a && source ".env" && set +a

export COUNTRY="${REFLECTOR_COUNTRY:-"Romania"}"

envsubst < "./configs/etc/xdg/reflector/reflector.conf" | \
sudo tee "/etc/xdg/reflector/reflector.conf" > /dev/null

service_enable reflector.timer
service_start reflector.timer

exit 0
