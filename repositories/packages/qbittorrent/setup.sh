#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

qBittorrent_config_dir="${HOME}/.config/qBittorrent"

install -D -m 644 \
  "${package_dir}/config/qBittorrent.conf" \
  "${qBittorrent_config_dir}/qBittorrent.conf"

exit 0
