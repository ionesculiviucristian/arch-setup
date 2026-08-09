#!/bin/bash
set -eu

# @see [shell](https://dystroy.org/broot/install-br/#automatic-shell-function-installation)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

broot_config_dir="${HOME}/.config/broot"
broot_config_file="${broot_config_dir}/conf.hjson"

mkdir -p "${broot_config_dir}"

broot --install >/dev/null
broot --write-default-conf "${broot_config_dir}"

file::replace_text \
  '^#\? *default_flags:.*' \
  'default_flags: "gh"' \
  "${broot_config_file}"

file::replace_text \
  '^#\? *icon_theme:.*' \
  'icon_theme: nerdfont' \
  "${broot_config_file}"

file::replace_text \
  '^#\? *quit_on_last_cancel:.*' \
  'quit_on_last_cancel: true' \
  "${broot_config_file}"

exit 0
