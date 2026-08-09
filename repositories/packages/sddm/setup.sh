#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

sddm_conf_dir="/etc/sddm.conf.d"

sudo install -D -m 644 \
  "${package_dir}/config/10-wayland.conf" \
  "${sddm_conf_dir}/10-wayland.conf"

sudo install -D -m 644 \
  "${package_dir}/config/kde_settings.conf" \
  "${sddm_conf_dir}/kde_settings.conf"

exit 0
