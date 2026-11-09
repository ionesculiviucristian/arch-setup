#!/bin/bash
set -eu

# @see [theme](https://github.com/catppuccin/kde?tab=readme-ov-file#installation)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

if [ $# -ne 2 ]; then
  log::error "Usage: $0 <flavour> <accent>"
  exit 2
fi

flavour="$1"
accent="$2"

wallpaper=$(theme::get '.wallpapers.login')

color_scheme="Catppuccin${flavour^}${accent^}"
cursors_theme="catppuccin-${flavour}-${accent}-cursors"
look_and_feel="Catppuccin-${flavour^}-${accent^}"

greeter_config_dir="/var/lib/plasmalogin/.config"
share_dir="${HOME}/.local/share"
wallpapers_dir="${HOME}/Pictures/Wallpapers"

sudo install -D -m 644 \
  "${share_dir}/color-schemes/${color_scheme}.colors" \
  "/usr/share/color-schemes/${color_scheme}.colors"

sudo rm -rf "/usr/share/plasma/look-and-feel/${look_and_feel}"

sudo cp -r \
  "${share_dir}/plasma/look-and-feel/${look_and_feel}" \
  "/usr/share/plasma/look-and-feel/${look_and_feel}"

sudo rm -rf "/usr/share/icons/${cursors_theme}"

sudo cp -r \
  "${share_dir}/icons/${cursors_theme}" \
  "/usr/share/icons/${cursors_theme}"

sudo chmod -R a+rX \
  "/usr/share/plasma/look-and-feel/${look_and_feel}" \
  "/usr/share/icons/${cursors_theme}"

sudo install -D -m 644 \
  "${wallpapers_dir}/${wallpaper}" \
  "/usr/share/wallpapers/arch-setup/login.png"

sudo install -D -m 644 \
  "${package_dir}/config/plasmalogin.conf" \
  "/etc/plasmalogin.conf"

sudo -u plasmalogin kwriteconfig6 \
  --file "${greeter_config_dir}/kdeglobals" \
  --group "KDE" \
  --key "LookAndFeelPackage" \
  "${look_and_feel}"

sudo -u plasmalogin kwriteconfig6 \
  --file "${greeter_config_dir}/kcminputrc" \
  --group "Mouse" \
  --key "cursorTheme" \
  "${cursors_theme}"

exit 0
