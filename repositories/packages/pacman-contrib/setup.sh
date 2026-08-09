#!/bin/bash
set -eu

# [config] https://man.archlinux.org/man/paccache.8
# [Default config] /etc/conf.d/pacman-contrib

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../scripts/installer.sh
source "${root_dir}/scripts/installer.sh"

paccache_config_file="/etc/conf.d/pacman-contrib"

# paccache.service runs `paccache -r $PACCACHE_ARGS`, and `-r` alone keeps the
# last 3 versions of every package. That grew the cache to 13 GB in a year, so
# keep a single version to downgrade to instead. See docs/NOTES.md.
sudo_replace_text \
  '^PACCACHE_ARGS=.*' \
  'PACCACHE_ARGS="-k1"' \
  "${paccache_config_file}"

# Weekly cleanup — the package ships the timer disabled.
sudo systemctl enable --now paccache.timer

exit 0
