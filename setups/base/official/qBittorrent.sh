#!/bin/bash
set -eu

# [Theme] https://github.com/catppuccin/qbittorrent

qBittorrent_dir="${HOME}/.config/qBittorrent"
qBittorrent_theme="catppuccin-mocha"

mkdir -p "${qBittorrent_dir}/themes"

wget -qO \
  "${qBittorrent_dir}/themes/${qBittorrent_theme}.qbtheme" \
  https://github.com/catppuccin/qbittorrent/releases/download/v2.0.1/${qBittorrent_theme}.qbtheme

cp \
  "configs/.config/qBittorrent/qBittorrent.conf" \
  "${qBittorrent_dir}/qBittorrent.conf"

sed -i  \
  "s|^General\\\\CustomUIThemePath=|General\\\\CustomUIThemePath=${qBittorrent_dir}/themes/${qBittorrent_theme}.qbtheme|" \
  "${qBittorrent_dir}/qBittorrent.conf"

sed -i  \
  "s|^General\\\\UseCustomUITheme=false|General\\\\UseCustomUITheme=true|" \
  "${qBittorrent_dir}/qBittorrent.conf"

exit 0
