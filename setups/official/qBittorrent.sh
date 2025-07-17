#!/bin/bash
set -eu

cp "configs/.config/qBittorrent/qBittorrent.conf" "${HOME}/.config/qBittorrent/qBittorrent.conf"

qBittorrent_themes_dir="${HOME}/.config/qBittorrent/themes"

mkdir -p "${qBittorrent_themes_dir}"

wget -qO \
  "${qBittorrent_themes_dir}/catppuccin-mocha.qbtheme" \
  https://github.com/catppuccin/qbittorrent/releases/download/v2.0.1/catppuccin-mocha.qbtheme

exit 0
