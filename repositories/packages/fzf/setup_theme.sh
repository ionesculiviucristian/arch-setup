#!/bin/bash
set -eu

# [theme] https://github.com/catppuccin/fzf?tab=readme-ov-file#usage
# [shell] https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration

if [ $# -ne 2 ]; then
  echo "Usage: $0 <flavour> <accent>"
  exit 1
fi

flavour="$1"
# accent="$2"

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

catppuccin_fzf_dir="${HOME}/.repos/catppuccin-fzf"

rm -rf "${catppuccin_fzf_dir}"

git clone -q --depth=1 \
  https://github.com/catppuccin/fzf.git \
  "${catppuccin_fzf_dir}"

"${root_dir}/scripts/setup_shell.sh" \
  --package "fzf" \
  --priority "50" \
  <<<"source \"\${HOME}/.repos/catppuccin-fzf/themes/catppuccin-fzf-${flavour}.sh\""

exit 0
