#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

sudo install -D -m 644 \
  "${package_dir}/config/filesystems.conf" \
  "/etc/modules-load.d/filesystems.conf"

sudo systemctl restart systemd-modules-load.service

exit 0
