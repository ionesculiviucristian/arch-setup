#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

sddm_conf_dir="/etc/sddm.conf.d"

sudo mkdir -p "${sddm_conf_dir}"

sudo cp \
  "${package_dir}/config/kde_settings.conf" \
  "${sddm_conf_dir}/kde_settings.conf"

exit 0
