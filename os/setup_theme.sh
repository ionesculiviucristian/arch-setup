#!/bin/bash
set -eu

# [theme] https://github.com/catppuccin/kde?tab=readme-ov-file#installation

if [ $# -ne 2 ]; then
  echo "Usage: $0 <flavour> <accent>"
  exit 1
fi

flavour="$1"
accent="$2"

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=../scripts/installer.sh
source "${root_dir}/scripts/installer.sh"

catppuccin_kde_dir="${HOME}/.repos/catppuccin-kde"
icons_dir="${HOME}/.local/share/icons"
cursors_theme="catppuccin-${flavour}-${accent}-cursors"

rm -rf "${catppuccin_kde_dir}"
rm -rf "${HOME}/.local/share/kpackage/generic/Catppuccin-"*

git clone -q --depth=1 \
  https://github.com/catppuccin/kde \
  "${catppuccin_kde_dir}"

(
  cd "${catppuccin_kde_dir}"
  printf "1\n4\n2\ny\ny" | ./install.sh >/dev/null

  rm -rf "${icons_dir}/Catppuccin-"*
  rm -rf "${icons_dir}/icons/${cursors_theme}"

  # Use newer Catppuccin cursors
  sudo_extract_from_url \
    "https://github.com/catppuccin/cursors/releases/download/v2.0.0/${cursors_theme}.zip" \
    "${icons_dir}"

  if [ ! -L "${HOME}/.icons" ]; then
    ln -s "${icons_dir}" "${HOME}/.icons"
  fi

  plasma-apply-cursortheme "${cursors_theme}" >/dev/null
)

exit 0
