#!/bin/bash
set -eu

# https://xyne.dev/projects/reflector/

export COUNTRY="${1:-"Romania"}"

envsubst < "./configs/etc/xdg/reflector/reflector.conf" | \
sudo tee "/etc/xdg/reflector/reflector.conf" > /dev/null

systemctl enable reflector.timer
systemctl start reflector.timer

exit 0
