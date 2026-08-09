# shellcheck shell=bash

# @description Allow sudo without a password.
# @noargs
sudoers::enable_passwordless() {
  # shellcheck disable=SC2155
  local passwordless_sudo_file="/etc/sudoers.d/$(whoami)"

  sudo rm -f "${passwordless_sudo_file}"

  echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" |
    sudo tee "${passwordless_sudo_file}" >/dev/null
}

# @description Require the sudo password again.
# @noargs
sudoers::disable_passwordless() {
  # shellcheck disable=SC2155
  sudo rm -f "/etc/sudoers.d/$(whoami)"
}
