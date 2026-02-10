#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

mkdir -p "${HOME}/.bash_aliases.d"
mkdir -p "${HOME}/.local/share/fonts"
mkdir -p "${HOME}/.repos"
mkdir -p "${HOME}/Backups/docker"
mkdir -p "${HOME}/Pictures/Wallpapers"
mkdir -p "${HOME}/Projects"

"${root_dir}/scripts/update_user_places.sh" "${HOME}/Backups" "Backups"
"${root_dir}/scripts/update_user_places.sh" "${HOME}/Projects" "Projects"

exit 0
