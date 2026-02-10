#!/bin/bash
set -eu

# [config] https://wiki.archlinux.org/title/Pacman

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

# shellcheck source=../../../scripts/installer.sh
source "${root_dir}/scripts/installer.sh"

pacman_config_file="/etc/pacman.conf"

sudo_replace_text '^#Color' 'Color' "${pacman_config_file}"
sudo_replace_text '^#VerbosePkgLists' 'VerbosePkgLists' "${pacman_config_file}"

if ! sudo grep -q '^ILoveCandy' "${pacman_config_file}"; then
  sudo sed -i '/^VerbosePkgLists/a ILoveCandy' "${pacman_config_file}"
fi

exit 0
