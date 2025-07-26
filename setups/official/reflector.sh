#!/bin/bash
# shellcheck disable=SC1091
set -eu

# https://xyne.dev/projects/reflector/

set -a && source ".env" && set +a

export COUNTRY="${REFLECTOR_COUNTRY:-"Romania"}"

envsubst < "./configs/etc/xdg/reflector/reflector.conf" | \
sudo tee "/etc/xdg/reflector/reflector.conf" > /dev/null

systemctl enable reflector.timer
systemctl start reflector.timer

exit 0
