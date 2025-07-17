#!/bin/bash
set -eu

qBittorrent_dir="${HOME}/.config/qBittorrent"

mkdir -p "${qBittorrent_dir}/themes"

cp \
  "configs/.config/qBittorrent/qBittorrent.conf" \
  "${qBittorrent_dir}/qBittorrent.conf"

wget -qO \
  "${qBittorrent_dir}/themes/catppuccin-mocha.qbtheme" \
  https://github.com/catppuccin/qbittorrent/releases/download/v2.0.1/catppuccin-mocha.qbtheme

exit 0
