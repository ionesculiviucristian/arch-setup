#!/bin/bash
set -eu

# shellcheck source=../_config.sh
source "./setups/base/_config.sh"

# shellcheck disable=SC1091
source "./scripts/installer.sh"

# shellcheck source=../../../themes/base/system/sddm.sh
source "./themes/base/system/sddm.sh"

sudo mkdir -p "${sddm_conf_dir}"

install_sddm_theme

sudo cp \
  "./configs/etc/sddm.conf.d/kde_settings.conf" \
  "${sddm_conf_dir}/kde_settings.conf"

exit 0
