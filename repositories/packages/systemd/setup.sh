#!/bin/bash
set -eu

# @see [wiki](https://wiki.archlinux.org/title/Improving_performance#Changing_I/O_scheduler)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

sudo install -D -m 644 \
  "${package_dir}/config/00-size.conf" \
  "/etc/systemd/journald.conf.d/00-size.conf"

sudo systemctl restart systemd-journald.service

sudo install -D -m 644 \
  "${package_dir}/config/60-ioschedulers.rules" \
  "/etc/udev/rules.d/60-ioschedulers.rules"

sudo udevadm control --reload
sudo udevadm trigger --subsystem-match=block --action=change

exit 0
