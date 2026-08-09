#!/bin/bash
set -eu

# [config] https://man.archlinux.org/man/sshd_config.5

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../scripts/installer.sh
source "${root_dir}/scripts/installer.sh"

sshd_config_file="/etc/ssh/sshd_config"

sudo_replace_text \
  '^#Port 22' \
  'Port 22' \
  "${sshd_config_file}"

sudo_replace_text \
  '^#PermitRootLogin prohibit-password' \
  'PermitRootLogin no' \
  "${sshd_config_file}"

sudo_replace_text \
  '^#PubkeyAuthentication yes' \
  'PubkeyAuthentication yes' \
  "${sshd_config_file}"

sudo_replace_text \
  '^#PasswordAuthentication yes' \
  'PasswordAuthentication no' \
  "${sshd_config_file}"

sudo_replace_text \
  '^#PermitEmptyPasswords no' \
  'PermitEmptyPasswords no' \
  "${sshd_config_file}"

sudo systemctl enable --now sshd.service

exit 0
