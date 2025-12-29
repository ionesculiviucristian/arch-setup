#!/bin/bash
set -eu

# shellcheck source=../../setups/b450-i-aorus-pro-wifi/_config.sh
source "./setups/b450-i-aorus-pro-wifi/_config.sh"

# shellcheck disable=SC1091
source "./scripts/installer.sh"

# ==========================================
# Update official package themes
# ==========================================

info "Updating official package themes..."

# shellcheck disable=SC1091
source "./themes/b450-i-aorus-pro-wifi/official/obs.sh"
info "  obs" && install_obs_theme

exit 0
