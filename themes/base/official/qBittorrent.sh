#!/bin/bash
set -eu

# shellcheck source=../../../setups/base/_config.sh
source "./setups/base/_config.sh"

install_qbittorrent_theme() {
  mkdir -p "${qBittorrent_dir}/themes"

  wget -qO \
    "${qBittorrent_dir}/themes/${qBittorrent_theme}.qbtheme" \
    https://github.com/catppuccin/qbittorrent/releases/download/v2.0.1/${qBittorrent_theme}.qbtheme

  sed -i  \
    "s|^General\\\\CustomUIThemePath=|General\\\\CustomUIThemePath=${qBittorrent_dir}/themes/${qBittorrent_theme}.qbtheme|" \
    "${qBittorrent_dir}/qBittorrent.conf"

  sed -i  \
    "s|^General\\\\UseCustomUITheme=false|General\\\\UseCustomUITheme=true|" \
    "${qBittorrent_dir}/qBittorrent.conf"
}
