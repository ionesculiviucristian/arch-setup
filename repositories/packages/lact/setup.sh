#!/bin/bash
set -eu

# @see [config](https://github.com/ilya-zlobintsev/LACT/blob/master/docs/CONFIG.md)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

grub::add_parameters "amdgpu.ppfeaturemask=0xfff7ffff"

sudo install -D -m 644 \
  "${package_dir}/config/config.yaml" \
  "/etc/lact/config.yaml"

sudo systemctl enable lactd.service
sudo systemctl restart lactd.service

exit 0
