#!/bin/bash
set -eu

# @see [config](https://github.com/akinomyoga/ble.sh/blob/master/blerc.template)
# @see [shell](https://github.com/akinomyoga/ble.sh?tab=readme-ov-file#13-set-up-bashrc)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

bashrc_file="${HOME}/.bashrc"

install -D -m 644 \
  "${package_dir}/config/.blerc" \
  "${HOME}/.blerc"

blesh_line="[[ \$- == *i* ]] && source -- /usr/share/blesh/ble.sh --attach=none"

if ! grep -qF "/usr/share/blesh/ble.sh" "${bashrc_file}"; then
  file::insert_after \
    '^\[\[ \$- != \*i\* \]\] && return' \
    "${blesh_line}" \
    "${bashrc_file}"
fi

bash::install_bashrc \
  --package "blesh" \
  --priority "99" \
  "${package_dir}/bashrc.sh"

exit 0
