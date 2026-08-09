#!/bin/bash
set -eu

# [config] https://github.com/akinomyoga/ble.sh/blob/master/blerc.template
# [shell] https://github.com/akinomyoga/ble.sh?tab=readme-ov-file#13-set-up-bashrc

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

bashrc_file="${HOME}/.bashrc"

cp "${package_dir}/config/.blerc" "${HOME}/.blerc"

blesh_line="[[ \$- == *i* ]] && source -- /usr/share/blesh/ble.sh --attach=none"

grep -qF "/usr/share/blesh/ble.sh" "${bashrc_file}" ||
  sed -i "/^\[\[ \$- != \*i\* \]\] && return/a ${blesh_line//&/\\&}" "${bashrc_file}"

"${root_dir}/scripts/setup_shell.sh" \
  --package "blesh" \
  --priority "99" \
  "${package_dir}/bashrc.sh"

exit 0
