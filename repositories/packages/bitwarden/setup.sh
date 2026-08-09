#!/bin/bash
set -eu

# [shell] https://bitwarden.com/help/ssh-agent/#configure-your-system-to-use-bitwarden-ssh-agent

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

"${root_dir}/scripts/setup_shell.sh" \
  --package "bitwarden" \
  --priority "20" \
  "${package_dir}/bashrc.sh"

exit 0
