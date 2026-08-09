#!/bin/bash
set -eu

# @see [config](https://wiki.archlinux.org/title/Pacman)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

pacman_config_file="/etc/pacman.conf"

file::replace_text --sudo \
  '^#Color' \
  'Color' \
  "${pacman_config_file}"

file::replace_text --sudo \
  '^#VerbosePkgLists' \
  'VerbosePkgLists' \
  "${pacman_config_file}"

file::insert_after --sudo \
  '^VerbosePkgLists' \
  'ILoveCandy' \
  "${pacman_config_file}"

sudo install -D -m 644 \
  "${package_dir}/config/makepkg.conf" \
  "/etc/makepkg.conf.d/arch-setup.conf"

exit 0
