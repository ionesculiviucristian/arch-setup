#!/bin/bash
set -eu

exec 1>install_asus-expertbook-p1503cva.log
exec 2>errors_asus-expertbook-p1503cva.log

# shellcheck disable=SC1091
source "./scripts/installer.sh"

trap disable_passwordless_sudo EXIT

# ==========================================
# Pre install
# ==========================================

info "Starting installation..."

enable_passwordless_sudo

# ==========================================
# Install drivers
# ==========================================

info "Installing drivers..." && ./installers/asus-expertbook-p1503cva/drivers.sh

exit 0
