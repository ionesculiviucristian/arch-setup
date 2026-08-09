#!/bin/bash
set -eu

# @see [config](https://github.com/kdave/btrfsmaintenance#settings)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

btrfsmaintenance_config_file="/etc/default/btrfsmaintenance"

file::replace_text --sudo \
  '^BTRFS_TRIM_PERIOD=.*' \
  'BTRFS_TRIM_PERIOD="none"' \
  "${btrfsmaintenance_config_file}"

file::replace_text --sudo \
  '^BTRFS_BALANCE_DUSAGE=.*' \
  'BTRFS_BALANCE_DUSAGE="5 10 20"' \
  "${btrfsmaintenance_config_file}"

sudo systemctl enable --now \
  btrfsmaintenance-refresh.path \
  btrfs-balance.timer \
  btrfs-scrub.timer

sudo systemctl start btrfsmaintenance-refresh.service

exit 0
