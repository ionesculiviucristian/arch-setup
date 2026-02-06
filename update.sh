#!/bin/bash
set -eu

exec 1>update_base.log
exec 2>update_errors_base.log

# shellcheck disable=SC1091
source "./scripts/installer.sh"

trap disable_passwordless_sudo EXIT

# ==========================================
# Pre update
# ==========================================

info "Starting update..."

enable_passwordless_sudo

# ==========================================
# Update official & AUR packages
# ==========================================

info "Updating official & AUR packages..." && yay -Syu

# ==========================================
# Update external packages
# ==========================================

info "Updating external packages..."
info "  git-scope" && installers/base/external/git-scope.sh

# ==========================================
# Update themes
# ==========================================

info "Updating themes..."

themes/base/update.sh

# ==========================================
# Post update
# ==========================================

info "Update finished"

exit 0
