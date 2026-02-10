#!/bin/bash
set -eu

# [config] https://www.gnu.org/software/grub/manual/grub/grub.html#Configuration

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

# shellcheck source=../../../scripts/installer.sh
source "${root_dir}/scripts/installer.sh"

grub_file="/etc/default/grub"

sudo_replace_text \
  '^GRUB_DEFAULT=0' \
  'GRUB_DEFAULT=saved' \
  "${grub_file}"
sudo_replace_text \
  '^#GRUB_SAVEDEFAULT=true' \
  'GRUB_SAVEDEFAULT=true' \
  "${grub_file}"
sudo_replace_text \
  '^#GRUB_DISABLE_SUBMENU=y' \
  'GRUB_DISABLE_SUBMENU=y' \
  "${grub_file}"
sudo_replace_text \
  '^GRUB_CMDLINE_LINUX_DEFAULT=".*"$' \
  'GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1 loglevel=4"' \
  "${grub_file}"
sudo_replace_text \
  '^#GRUB_DISABLE_OS_PROBER=false' \
  'GRUB_DISABLE_OS_PROBER=false' \
  "${grub_file}"

sudo grub-mkconfig -o "/boot/grub/grub.cfg" >/dev/null

exit 0
