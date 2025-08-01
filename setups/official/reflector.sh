#!/bin/bash
set -eu

# [Config] https://xyne.dev/projects/reflector/

# shellcheck disable=SC1091
set -a && source ".env" && set +a

export COUNTRY="${REFLECTOR_COUNTRY}"

envsubst < "./configs/etc/xdg/reflector/reflector.conf" | \
  sudo tee "/etc/xdg/reflector/reflector.conf" >/dev/null

sudo systemctl enable reflector.timer >/dev/null
sudo systemctl start reflector.timer

exit 0
