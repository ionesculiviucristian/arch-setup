#!/bin/bash
set -eu

mkdir -p "${HOME}/.bash_aliases.d"
mkdir -p "${HOME}/.local/share/fonts"
mkdir -p "${HOME}/.repos"
mkdir -p "${HOME}/Backups/docker"
mkdir -p "${HOME}/Pictures/Wallpapers"
mkdir -p "${HOME}/Projects"

./scripts/update_user_places.sh "${HOME}/Backups" "Backups"
./scripts/update_user_places.sh "${HOME}/Projects" "Projects"

exit 0
