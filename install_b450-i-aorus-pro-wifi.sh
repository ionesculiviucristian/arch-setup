#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

exec 1>install_b450-i-aorus-pro-wifi.log
exec 2>install_errors_b450-i-aorus-pro-wifi.log

# shellcheck source=scripts/installer.sh
source "${root_dir}/scripts/installer.sh"
# shellcheck source=scripts/packages.sh
source "${root_dir}/scripts/packages.sh"

trap 'enable_kernel_updates; disable_passwordless_sudo' EXIT

# ==========================================
# Pre install
# ==========================================

info "Starting installation..."

enable_passwordless_sudo
disable_kernel_updates

# ==========================================
# Install official packages
# ==========================================

_t=$SECONDS
info "Installing official packages..."
# shellcheck disable=SC2046
sudo pacman \
  -Syu \
  --needed \
  --noconfirm \
  $(get_packages_by_repo b450-i-aorus-pro-wifi core extra multilib) >/dev/null
info "Installing official packages done in $(( SECONDS - _t ))s"

# ==========================================
# Install AUR packages
# ==========================================

_t=$SECONDS
info "Installing AUR packages..."
# shellcheck disable=SC2046
yay \
  -Syu \
  --needed \
  --noconfirm \
  $(get_packages_by_repo b450-i-aorus-pro-wifi aur) >/dev/null
info "Installing AUR packages done in $(( SECONDS - _t ))s"

# ==========================================
# Setup packages
# ==========================================

info "Setup packages..."
run_package_scripts b450-i-aorus-pro-wifi setup

exit 0
