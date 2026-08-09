#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

qBittorrent_config_dir="${HOME}/.config/qBittorrent"

mkdir -p "${qBittorrent_config_dir}/themes"

cp \
  "${package_dir}/config/qBittorrent.conf" \
  "${qBittorrent_config_dir}/qBittorrent.conf"

exit 0
