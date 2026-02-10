#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

sddm_conf_dir="/etc/sddm.conf.d"

sudo mkdir -p "${sddm_conf_dir}"

sudo cp \
  "${root_dir}/repositories/packages/sddm/config/kde_settings.conf" \
  "${sddm_conf_dir}/kde_settings.conf"

exit 0
