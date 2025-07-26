#!/bin/bash
set -eu

# https://github.com/catppuccin/qbittorrent

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

qBittorrent_dir="${HOME}/.config/qBittorrent"

_mkdir "${qBittorrent_dir}/themes"

download \
  "${qBittorrent_dir}/themes/catppuccin-mocha.qbtheme" \
  https://github.com/catppuccin/qbittorrent/releases/download/v2.0.1/catppuccin-mocha.qbtheme

_cp \
  "configs/.config/qBittorrent/qBittorrent.conf" \
  "${qBittorrent_dir}/qBittorrent.conf"

sed -i  \
  "s|^General\\\\CustomUIThemePath=|General\\\\CustomUIThemePath=${qBittorrent_dir}/themes/catppuccin-mocha.qbtheme|" \
  "${qBittorrent_dir}/qBittorrent.conf"

sed -i  \
  "s|^General\\\\UseCustomUITheme=false|General\\\\UseCustomUITheme=true|" \
  "${qBittorrent_dir}/qBittorrent.conf"

exit 0
