#!/bin/bash
set -eu

# [theme] https://github.com/catppuccin/qbittorrent?tab=readme-ov-file#usage

if [ $# -ne 2 ]; then
  echo "Usage: $0 <flavour> <accent>"
  exit 1
fi

flavour="$1"
# accent="$2"

qBittorrent_dir="${HOME}/.config/qBittorrent"
qBittorrent_theme="catppuccin-${flavour}"

mkdir -p "${qBittorrent_dir}/themes"

wget -qO \
  "${qBittorrent_dir}/themes/${qBittorrent_theme}.qbtheme" \
  "https://github.com/catppuccin/qbittorrent/releases/download/v2.0.1/${qBittorrent_theme}.qbtheme"

sed -i \
  "s|^General\\\\CustomUIThemePath=.*|General\\\\CustomUIThemePath=${qBittorrent_dir}/themes/${qBittorrent_theme}.qbtheme|" \
  "${qBittorrent_dir}/qBittorrent.conf"

sed -i \
  "s|^General\\\\UseCustomUITheme=.*|General\\\\UseCustomUITheme=true|" \
  "${qBittorrent_dir}/qBittorrent.conf"

exit 0
