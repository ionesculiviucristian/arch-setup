#!/bin/bash
set -eu

# shellcheck disable=SC1091
source "./scripts/installer.sh"

sudo_replace_text '^#Color' 'Color' "/etc/pacman.conf"

exit 0
