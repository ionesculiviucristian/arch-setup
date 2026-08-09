#!/bin/bash
set -eu

# @see [config](https://www.gnu.org/software/grub/manual/grub/grub.html#Configuration)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

grub_file="/etc/default/grub"

file::replace_text --sudo \
  '^GRUB_DEFAULT=0' \
  'GRUB_DEFAULT=saved' \
  "${grub_file}"

file::replace_text --sudo \
  '^#GRUB_SAVEDEFAULT=true' \
  'GRUB_SAVEDEFAULT=true' \
  "${grub_file}"

file::replace_text --sudo \
  '^#GRUB_DISABLE_SUBMENU=y' \
  'GRUB_DISABLE_SUBMENU=y' \
  "${grub_file}"

file::insert_after --sudo \
  '^GRUB_DISABLE_SUBMENU=y' \
  'GRUB_DISABLE_BOOTNEXT=true' \
  "${grub_file}"

grub::add_parameters "quiet" "loglevel=3"

exit 0
