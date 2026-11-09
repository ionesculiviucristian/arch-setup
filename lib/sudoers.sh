# shellcheck shell=bash

# @description Allow sudo without a password.
# @noargs
sudoers::enable_passwordless() {
  local user file
  user=$(whoami)
  file="/etc/sudoers.d/${user}"

  sudo rm -f "${file}"

  echo "${user} ALL=(ALL) NOPASSWD: ALL" | sudo tee "${file}" >/dev/null
}

# @description Require the sudo password again.
# @noargs
sudoers::disable_passwordless() {
  sudo rm -f "/etc/sudoers.d/$(whoami)"
}
