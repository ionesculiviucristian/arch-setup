#!/bin/bash
set -eu

# [Config] https://wiki.archlinux.org/title/Pacman

# shellcheck source=../_config.sh
source "./setups/base/_config.sh"

# shellcheck disable=SC1091
source "./scripts/installer.sh"

sudo_replace_text '^#Color' 'Color' "${pacman_config_file}"
sudo_replace_text '^#VerbosePkgLists' 'VerbosePkgLists' "${pacman_config_file}"

if ! sudo grep -q '^ILoveCandy' "${pacman_config_file}"; then
  sudo sed -i '/^VerbosePkgLists/a ILoveCandy' "${pacman_config_file}"
fi

exit 0
