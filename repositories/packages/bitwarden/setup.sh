#!/bin/bash
set -eu

# @see [shell](https://bitwarden.com/help/ssh-agent/#configure-your-system-to-use-bitwarden-ssh-agent)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

bash::install_bashrc \
  --package "bitwarden" \
  --priority "20" \
  "${package_dir}/bashrc.sh"

autostart_dir="${HOME}/.config/autostart"

mkdir -p "${autostart_dir}"

cp \
  "/usr/share/applications/bitwarden.desktop" \
  "${autostart_dir}/bitwarden.desktop"

exit 0
