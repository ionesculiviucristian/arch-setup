#!/bin/bash
set -eu

# [config] https://www.gnu.org/software/grub/manual/grub/grub.html#Configuration

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../scripts/installer.sh
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
  '^\(GRUB_CMDLINE_LINUX_DEFAULT=".*\)loglevel=[0-9]\+' \
  '\1loglevel=4' \
  "${grub_file}"
sudo_replace_text \
  '^#GRUB_DISABLE_OS_PROBER=false' \
  'GRUB_DISABLE_OS_PROBER=false' \
  "${grub_file}"

sudo grub-mkconfig -o "/boot/grub/grub.cfg" >/dev/null

exit 0
