#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

exec 1>install_base.log
exec 2>install_errors_base.log

# shellcheck source=scripts/installer.sh
source "${root_dir}/scripts/installer.sh"
# shellcheck source=scripts/packages.sh
source "${root_dir}/scripts/packages.sh"

# Usage: ./install.sh [phase...]
# Phases: pre, packages, resources, external, aur, system-setups, setups, themes, post
_phases=("${@}")
phase() { [[ ${#_phases[@]} -eq 0 ]] || [[ " ${_phases[*]} " == *" $1 "* ]]; }

trap 'enable_kernel_updates; disable_passwordless_sudo' EXIT

install_start=$SECONDS

info "Starting installation..."

enable_passwordless_sudo
disable_kernel_updates

[ ! -f "${root_dir}/.env" ] && cp "${root_dir}/.env.example" "${root_dir}/.env"

# ==========================================
# Pre install
# ==========================================

if phase pre; then
  timed "Setup system" "${root_dir}/os/setup.sh"
fi

# ==========================================
# Install official packages
# ==========================================

if phase packages; then
  _t=$SECONDS
  info "Installing official packages..."
  # shellcheck disable=SC2046
  sudo pacman \
    -Syu \
    --needed \
    --noconfirm \
    $(get_packages_by_repo base core extra multilib) >/dev/null
  info "Installing official packages done in $(( SECONDS - _t ))s"
fi

# ==========================================
# Setup system resources
# ==========================================

if phase resources; then
  _t=$SECONDS
  info "Setup system resources..."
  info "  Creating directories" && "${root_dir}/os/scripts/setup_directories.sh"
  info "  Installing fonts" && "${root_dir}/os/scripts/install_fonts.sh"
  info "  Copying wallpapers" && "${root_dir}/os/scripts/setup_wallpapers.sh"
  info "Setup system resources done in $(( SECONDS - _t ))s"
fi

# ==========================================
# Install external packages
# ==========================================

if phase external; then
  _t=$SECONDS
  info "Installing external packages..."
  run_package_scripts base install
  info "Installing external packages done in $(( SECONDS - _t ))s"
fi

# ==========================================
# Install AUR packages
# ==========================================

if phase aur; then
  _t=$SECONDS
  info "Installing AUR packages..."
  # shellcheck disable=SC2046
  yay \
    -Syu \
    --needed \
    --noconfirm \
    $(get_packages_by_repo base aur) >/dev/null
  info "Installing AUR packages done in $(( SECONDS - _t ))s"
fi

# ==========================================
# Setup system packages
# ==========================================

if phase system-setups; then
  _t=$SECONDS
  info "Setup system packages..."
  info "  Night Color" && "${root_dir}/os/scripts/setup_night_color.sh"
  info "Setup system packages done in $(( SECONDS - _t ))s"
fi

# ==========================================
# Setup packages
# ==========================================

if phase setups; then
  _t=$SECONDS
  info "Setup packages..."
  run_package_scripts base setup
  info "Setup packages done in $(( SECONDS - _t ))s"
fi

# ==========================================
# Setup themes
# ==========================================

if phase themes; then
  _t=$SECONDS
  info "Setup themes..."
  "${root_dir}/os/setup_theme.sh"
  info "Setup themes done in $(( SECONDS - _t ))s"
fi

# ==========================================
# Post install
# ==========================================

if phase post; then
  _t=$SECONDS
  info "Finalizing bash..."

  "${root_dir}/scripts/update_bashrc.sh" "blesh" <<'EOF'
[[ ${BLE_VERSION-} ]] && ble-attach
EOF
  info "Finalizing bash done in $(( SECONDS - _t ))s"
fi

info "Installation finished in $(( SECONDS - install_start ))s"

info "After reboot run ${root_dir}/repositories/packages/docker/setup.sh"

exit 0
