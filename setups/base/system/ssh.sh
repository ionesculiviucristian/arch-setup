#!/bin/bash
set -eu

# shellcheck disable=SC1091
source "./scripts/installer.sh"

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

sudo_replace_text \
  '^UsePAM yes' \
  'UsePAM no' \
  "${sshd_config_file}"

sudo systemctl enable sshd.service
sudo systemctl start sshd.service

exit 0
