#!/bin/bash
set -eu

# @see [theme](https://github.com/catppuccin/tmux?tab=readme-ov-file#installation)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

if [ $# -ne 2 ]; then
  log::error "Usage: $0 <flavour> <accent>"
  exit 2
fi

flavour="$1"

file::replace_text \
  '^set -g @catppuccin_flavor .*' \
  "set -g @catppuccin_flavor \"${flavour}\"" \
  "${HOME}/.tmux.conf"

exit 0
