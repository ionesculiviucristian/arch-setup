#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

exec 1>install_asus-expertbook-p1503cva.log
exec 2>install_errors_asus-expertbook-p1503cva.log

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
# Install drivers
# ==========================================

_t=$SECONDS
info "Installing drivers..."
# shellcheck disable=SC2046
sudo pacman \
  -Syu \
  --needed \
  --noconfirm \
  $(get_packages_by_repo asus-expertbook-p1503cva core extra multilib) >/dev/null
info "Installing drivers done in $(( SECONDS - _t ))s"

exit 0
