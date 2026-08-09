#!/bin/bash
set -eu

# @see [theme](https://github.com/catppuccin/qbittorrent?tab=readme-ov-file#usage)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

if [ $# -ne 2 ]; then
  log::error "Usage: $0 <flavour> <accent>"
  exit 2
fi

flavour="$1"

qBittorrent_config_dir="${HOME}/.config/qBittorrent"
qBittorrent_theme="catppuccin-${flavour}"
qBittorrent_config_file="${qBittorrent_config_dir}/qBittorrent.conf"

mkdir -p "${qBittorrent_config_dir}/themes"

request::download \
  "https://github.com/catppuccin/qbittorrent/releases/latest/download/${qBittorrent_theme}.qbtheme" \
  "${qBittorrent_config_dir}/themes/${qBittorrent_theme}.qbtheme"

file::replace_text \
  '^General\\CustomUIThemePath=.*' \
  "General\\\\CustomUIThemePath=${qBittorrent_config_dir}/themes/${qBittorrent_theme}.qbtheme" \
  "${qBittorrent_config_file}"

file::replace_text \
  '^General\\UseCustomUITheme=.*' \
  'General\\UseCustomUITheme=true' \
  "${qBittorrent_config_file}"

exit 0
