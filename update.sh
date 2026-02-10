#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

exec 1>update_base.log
exec 2>update_errors_base.log

# shellcheck source=scripts/installer.sh
source "${root_dir}/scripts/installer.sh"
# shellcheck source=scripts/packages.sh
source "${root_dir}/scripts/packages.sh"

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
run_package_scripts base install

# ==========================================
# Update themes
# ==========================================

info "Updating themes..."

"${root_dir}/os/setup_theme.sh"

# ==========================================
# Post update
# ==========================================

info "Update finished"

exit 0
