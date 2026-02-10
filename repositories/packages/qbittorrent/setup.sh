#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

qBittorrent_dir="${HOME}/.config/qBittorrent"

mkdir -p "${qBittorrent_dir}/themes"

cp \
  "${root_dir}/repositories/packages/qbittorrent/config/qBittorrent.conf" \
  "${qBittorrent_dir}/qBittorrent.conf"

exit 0
