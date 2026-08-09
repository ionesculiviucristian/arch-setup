#!/bin/bash
set -eu

# [config] https://wiki.archlinux.org/title/Pacman

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../scripts/installer.sh
source "${root_dir}/scripts/installer.sh"

pacman_config_file="/etc/pacman.conf"

sudo_replace_text '^#Color' 'Color' "${pacman_config_file}"
sudo_replace_text '^#VerbosePkgLists' 'VerbosePkgLists' "${pacman_config_file}"

if ! sudo grep -q '^ILoveCandy' "${pacman_config_file}"; then
  sudo sed -i '/^VerbosePkgLists/a ILoveCandy' "${pacman_config_file}"
fi

exit 0
