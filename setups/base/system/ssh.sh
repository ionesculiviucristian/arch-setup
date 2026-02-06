#!/bin/bash
set -eu

# shellcheck source=../_config.sh
source "./setups/base/_config.sh"

# shellcheck disable=SC1091
source "./scripts/installer.sh"

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

sudo_replace_text \
  '^UsePAM yes' \
  'UsePAM no' \
  "${sshd_config_file}"

sudo systemctl enable --now sshd.service

exit 0
