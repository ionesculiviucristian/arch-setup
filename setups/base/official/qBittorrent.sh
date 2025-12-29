#!/bin/bash
set -eu

# [Theme] https://github.com/catppuccin/qbittorrent

# shellcheck source=../_config.sh
source "./setups/base/_config.sh"

# shellcheck source=../../../themes/base/official/qBittorrent.sh
source "./themes/base/official/qBittorrent.sh"

cp \
  "configs/.config/qBittorrent/qBittorrent.conf" \
  "${qBittorrent_dir}/qBittorrent.conf"

install_qbittorrent_theme

exit 0
