#!/bin/bash
set -eu

# @see [config](https://wiki.archlinux.org/title/Zram)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

grub::add_parameters "zswap.enabled=0"

sudo install -D -m 644 \
  "${package_dir}/config/zram-generator.conf" \
  "/etc/systemd/zram-generator.conf"

sudo install -D -m 644 \
  "${package_dir}/config/99-zram.conf" \
  "/etc/sysctl.d/99-zram.conf"

sudo systemctl daemon-reload
sudo sysctl --system >/dev/null

exit 0
