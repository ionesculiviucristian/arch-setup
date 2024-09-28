#!/bin/bash
set -eu

resolv_file="/etc/resolv.conf"
resolved_dir="/etc/systemd/resolved.conf.d"

sudo mkdir -p "${resolved_dir}"

sudo cp \
  "./configs/etc/systemd/resolved.conf.d/adguard.conf" \
  "${resolved_dir}/adguard.conf"

sudo systemctl restart systemd-resolved

sudo rm -f "${resolv_file}"
sudo ln -s "/run/systemd/resolve/resolv.conf" "${resolv_file}"

sudo systemctl enable adguardhome.service
sudo systemctl start adguardhome.service

exit 0
