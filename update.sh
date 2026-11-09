#!/bin/bash
set -eu

# @description Update the official, AUR (including -git) and external packages, the fonts and the tools of the packages with an update.sh.
# @arg $1 string Profile folder name (optional, default: base)
# @option --themes Apply the themes after the update
# @option --debug Print debug messages, same as ARCH_SETUP_DEBUG=1

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/index.sh
source "${root_dir}/lib/index.sh"

profile="base"

if [ $# -gt 0 ] && [[ "$1" != -* ]]; then
  profile=$1
  shift
fi

if [[ " $* " == *" --debug "* ]]; then
  export ARCH_SETUP_DEBUG=1
fi

installer::redirect_logs update "${profile}"

trap sudoers::disable_passwordless EXIT

# ==========================================
# Pre update
# ==========================================

log::info "Starting update..."

sudoers::enable_passwordless

# ==========================================
# Update official & AUR packages
# ==========================================

log::info "Updating official & AUR packages..." && yay -Syu --devel --noconfirm
installer::install_requirements

# ==========================================
# Update fonts
# ==========================================

log::info "Updating fonts..."
font::install_external

# ==========================================
# Update package tools
# ==========================================

log::info "Updating package tools..."
for pkg_dir in $(profile::installed_dirs); do
  profile::run_script "${pkg_dir}" update
done

for dir in "${arch_setup_dirs[@]}"; do
  for pkg_dir in "${dir}/profiles/${profile}/packages"/*/; do
    [ -d "${pkg_dir}" ] || continue

    profile::run_script "${pkg_dir%/}" update
  done
done

# ==========================================
# Update themes
# ==========================================

if [[ " $* " == *" --themes "* ]]; then
  log::info "Updating themes..."
  theme::apply
  grub::update_config
fi

# ==========================================
# Post update
# ==========================================

log::info "Update finished"

exit 0
