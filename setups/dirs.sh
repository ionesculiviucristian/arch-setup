#!/bin/bash
set -eu

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

_mkdir "${HOME}/.bash_aliases.d"
_mkdir "${HOME}/.local/share/fonts"
_mkdir "${HOME}/.repos"
_mkdir "${HOME}/Backups/docker"
_mkdir "${HOME}/Pictures/Wallpapers"
_mkdir "${HOME}/Projects"

./scripts/update_user_places.sh "${HOME}/Backups" "Backups"
./scripts/update_user_places.sh "${HOME}/Projects" "Projects"

exit 0
