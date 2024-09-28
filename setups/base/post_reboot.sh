#!/bin/bash
set -eu

exec 1>install_post.log
exec 2>errors_post.log

# shellcheck disable=SC1091
source "./scripts/installer.sh"

trap disable_passwordless_sudo EXIT

info "Starting installation..."

enable_passwordless_sudo

info "Setup Docker..." && ./setups/base/official/docker.sh

info "Installation finished"

exit 0
