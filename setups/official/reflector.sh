#!/bin/bash
set -eu

# https://xyne.dev/projects/reflector/

sudo cp \
  "./configs/etc/xdg/reflector/reflector.conf" \
  "/etc/xdg/reflector/reflector.conf"

systemctl enable reflector.timer
systemctl start reflector.timer

exit 0
