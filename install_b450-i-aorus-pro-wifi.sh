#!/bin/bash
set -eu

exec 1>install_b450-i-aorus-pro-wifi.log
exec 2>errors_b450-i-aorus-pro-wifi.log

# shellcheck disable=SC1091
source "./scripts/installer.sh"

trap disable_passwordless_sudo EXIT

# ==========================================
# Pre install
# ==========================================

info "Starting installation..."

enable_passwordless_sudo

# ==========================================
# Install official packages
# ==========================================

info "Installing official packages..."
./installers/b450-i-aorus-pro-wifi/official_packages.sh

# ==========================================
# Install AUR packages
# ==========================================

info "Installing AUR packages..."
./installers/b450-i-aorus-pro-wifi/aur_packages.sh

# ==========================================
# Setup official packages
# ==========================================

info "Setup official packages..."
info "  OBS Studio" && ./setups/b450-i-aorus-pro-wifi/official/obs_studio.sh

# ==========================================
# Setup AUR packages
# ==========================================

info "Setup AUR packages..."
info "  ProFTPD" && ./setups/b450-i-aorus-pro-wifi/aur/proftpd.sh

# ==========================================
# Install drivers
# ==========================================

info "Installing drivers..." && ./installers/b450-i-aorus-pro-wifi/drivers.sh

exit 0
