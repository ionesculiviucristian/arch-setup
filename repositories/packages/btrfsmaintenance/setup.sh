#!/bin/bash
set -eu

# [config] https://github.com/kdave/btrfsmaintenance#configuration
# [Default config] /etc/default/btrfsmaintenance

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../scripts/installer.sh
source "${root_dir}/scripts/installer.sh"

btrfsmaintenance_config_file="/etc/default/btrfsmaintenance"

# fstrim.timer is left disabled, so without this the SSD is never trimmed.
sudo_replace_text \
  '^BTRFS_TRIM_PERIOD=.*' \
  'BTRFS_TRIM_PERIOD="weekly"' \
  "${btrfsmaintenance_config_file}"

# The stock "5 10" thresholds are too conservative to reclaim enough block
# groups on an almost full filesystem.
sudo_replace_text \
  '^BTRFS_BALANCE_DUSAGE=.*' \
  'BTRFS_BALANCE_DUSAGE="5 10 20"' \
  "${btrfsmaintenance_config_file}"

# The package only ships the units, it never enables them.
sudo systemctl enable --now \
  btrfsmaintenance-refresh.path \
  btrfs-balance.timer \
  btrfs-scrub.timer \
  btrfs-trim.timer

# The timers ship with OnCalendar=monthly and only this service translates the
# config periods into timer drop-ins. The .path unit picks up later edits to the
# config, but not the ones made above, so trigger the refresh once by hand.
# See docs/NOTES.md.
sudo systemctl start btrfsmaintenance-refresh.service

exit 0
