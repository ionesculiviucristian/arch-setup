#!/bin/bash
set -eu

# @see [theme](https://github.com/catppuccin/fzf?tab=readme-ov-file#usage)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

if [ $# -ne 2 ]; then
  log::error "Usage: $0 <flavour> <accent>"
  exit 2
fi

flavour="$1"

catppuccin_fzf_dir="${HOME}/.cache/arch-setup/catppuccin-fzf"

rm -rf "${catppuccin_fzf_dir}"

git clone -q --depth=1 \
  https://github.com/catppuccin/fzf.git \
  "${catppuccin_fzf_dir}"

bash::install_bashrc \
  --package "fzf-theme" \
  --priority "50" \
  "${catppuccin_fzf_dir}/themes/catppuccin-fzf-${flavour}.sh"

exit 0
