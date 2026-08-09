#!/bin/bash
set -eu

# @see [theme](https://github.com/catppuccin/kde?tab=readme-ov-file#installation)

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=SCRIPTDIR/../lib/index.sh
source "${root_dir}/lib/index.sh"

if [ $# -ne 2 ]; then
  log::error "Usage: $0 <flavour> <accent>"
  exit 2
fi

flavour="$1"
accent="$2"

wallpaper=$(theme::get '.wallpapers.kde')

catppuccin_kde_dir="${HOME}/.cache/arch-setup/catppuccin-kde"
icons_dir="${HOME}/.local/share/icons"
cursors_theme="catppuccin-${flavour}-${accent}-cursors"
wallpapers_dir="${HOME}/Pictures/Wallpapers"

declare -A flavour_ids=(
  [frappe]=3
  [latte]=4
  [macchiato]=2
  [mocha]=1
)
declare -A accent_ids=(
  [blue]=13
  [flamingo]=2
  [green]=9
  [lavender]=14
  [maroon]=6
  [mauve]=4
  [peach]=7
  [pink]=3
  [red]=5
  [rosewater]=1
  [sapphire]=12
  [sky]=11
  [teal]=10
  [yellow]=8
)

rm -rf "${catppuccin_kde_dir}"

git clone -q --depth=1 \
  https://github.com/catppuccin/kde \
  "${catppuccin_kde_dir}"

rm -rf "${HOME}/.local/share/kpackage/generic/Catppuccin-"*

(
  cd "${catppuccin_kde_dir}"
  ./install.sh --quiet --no-cursor "${flavour_ids[${flavour}]}" "${accent_ids[${accent}]}" 2 >/dev/null

  rm -rf "${icons_dir}/Catppuccin-"*
  rm -rf "${icons_dir:?}/${cursors_theme}"

  mkdir -p "${icons_dir}"

  request::extract \
    "https://github.com/catppuccin/cursors/releases/latest/download/${cursors_theme}.zip" \
    "${icons_dir}"

  if [ ! -L "${HOME}/.icons" ]; then
    ln -s "${icons_dir}" "${HOME}/.icons"
  fi

  plasma-apply-cursortheme "${cursors_theme}" >/dev/null
)

plasma-apply-wallpaperimage \
  "${wallpapers_dir}/${wallpaper}" >/dev/null

exit 0
