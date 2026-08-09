#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

grub::add_parameters "acpi_enforce_resources=lax"

sudo install -D -m 644 \
  "${package_dir}/config/it87.conf" \
  "/etc/modules-load.d/it87.conf"

if grep -qw "acpi_enforce_resources=lax" /proc/cmdline; then
  sudo systemctl restart systemd-modules-load.service
else
  log::info "  it87 loads after reboot"
fi

exit 0
