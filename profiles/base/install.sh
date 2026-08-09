#!/bin/bash
set -eu

# @description Run every install phase, or only the given ones; themes only with --themes or the themes phase.
# @option --themes Apply the themes after the other phases
# @option --debug Print debug messages, same as ARCH_SETUP_DEBUG=1
# @arg $@ string Phases: pre, packages, external, aur, setups, resources, themes (optional)

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# shellcheck source=SCRIPTDIR/../../lib/index.sh
source "${root_dir}/lib/index.sh"

installer::start base "$@"

if installer::phase_enabled pre; then
  _t=${SECONDS}
  log::info "Setup system..."
  "${root_dir}/os/setup.sh"
  log::info "Setup system done in $((SECONDS - _t))s"
fi

installer::install_profile base

if installer::phase_enabled resources; then
  _t=${SECONDS}
  log::info "Installing fonts..."
  font::install_external
  log::info "Installing fonts done in $((SECONDS - _t))s"
fi

installer::finish

exit 0
