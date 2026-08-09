#!/bin/bash
set -eu

# @see [config](https://github.com/sharkdp/bat?tab=readme-ov-file#configuration-file)
# @see [shell](https://github.com/sharkdp/bat?tab=readme-ov-file#man)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

bat_config_dir="${HOME}/.config/bat"

install -D -m 644 \
  "${package_dir}/config/config" \
  "${bat_config_dir}/config"

bash::install_bashrc \
  --package "bat" \
  --priority "20" \
  "${package_dir}/bashrc.sh"

exit 0
