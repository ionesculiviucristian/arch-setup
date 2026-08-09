#!/bin/bash
set -eu

# @see [theme](https://github.com/catppuccin/lazygit?tab=readme-ov-file#installation)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

if [ $# -ne 2 ]; then
  log::error "Usage: $0 <flavour> <accent>"
  exit 2
fi

flavour="$1"
accent="$2"

lazygit_config_dir="${HOME}/.config/lazygit"

mkdir -p "${lazygit_config_dir}"

request::download \
  "https://raw.githubusercontent.com/catppuccin/lazygit/refs/heads/main/themes-mergable/${flavour}/${accent}.yml" \
  "${lazygit_config_dir}/theme.yml"

bash::install_bashrc \
  --package "lazygit-theme" \
  --priority "50" \
  "${package_dir}/bashrc-theme.sh"

exit 0
