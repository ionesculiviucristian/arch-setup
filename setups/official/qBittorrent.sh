#!/bin/bash
set -eu

# https://github.com/catppuccin/qbittorrent

qBittorrent_dir="${HOME}/.config/qBittorrent"

mkdir -p "${qBittorrent_dir}/themes"

wget -qO \
  "${qBittorrent_dir}/themes/catppuccin-mocha.qbtheme" \
  https://github.com/catppuccin/qbittorrent/releases/download/v2.0.1/catppuccin-mocha.qbtheme

cp \
  "configs/.config/qBittorrent/qBittorrent.conf" \
  "${qBittorrent_dir}/qBittorrent.conf"

sed -i  \
  "s|^General\\\\CustomUIThemePath=|General\\\\CustomUIThemePath=${qBittorrent_dir}/themes/catppuccin-mocha.qbtheme|" \
  "${qBittorrent_dir}/qBittorrent.conf"

sed -i  \
  "s|^General\\\\UseCustomUITheme=false|General\\\\UseCustomUITheme=true|" \
  "${qBittorrent_dir}/qBittorrent.conf"

exit 0
