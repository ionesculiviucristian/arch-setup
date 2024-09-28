#!/bin/bash
set -eu

# ==========================================
# Pre install
# ==========================================

PASSWORDLESS_SUDO_FILE="/etc/sudoers.d/$(whoami)"

sudo rm -f "${PASSWORDLESS_SUDO_FILE}"

echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" | \
  sudo tee "${PASSWORDLESS_SUDO_FILE}" >/dev/null

# ==========================================
# Install official packages
# ==========================================

./installers/b450-i-aorus-pro-wifi/official_packages.sh

# ==========================================
# Install AUR packages
# ==========================================

./installers/b450-i-aorus-pro-wifi/aur_packages.sh

# ==========================================
# Setup official packages
# ==========================================

./setups/b450-i-aorus-pro-wifi/official/obs_studio.sh

# ==========================================
# Setup AUR packages
# ==========================================

./setups/b450-i-aorus-pro-wifi/aur/proftpd.sh

# ==========================================
# Install drivers
# ==========================================

./installers/b450-i-aorus-pro-wifi/drivers.sh

# ==========================================
# Post install
# ==========================================

sudo rm -f "${PASSWORDLESS_SUDO_FILE}"

exit 0
