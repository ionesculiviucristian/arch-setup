#!/bin/bash
set -eu

exec 1>install_asus-expertbook-p1503cva.log
exec 2>install_errors_asus-expertbook-p1503cva.log

# shellcheck disable=SC1091
source "./scripts/installer.sh"

trap 'enable_kernel_updates; disable_passwordless_sudo' EXIT

# ==========================================
# Pre install
# ==========================================

info "Starting installation..."

enable_passwordless_sudo
disable_kernel_updates

# ==========================================
# Install drivers
# ==========================================

info "Installing drivers..." && ./installers/asus-expertbook-p1503cva/drivers.sh

exit 0
