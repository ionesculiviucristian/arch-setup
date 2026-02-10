#!/bin/bash
set -eu

# [shell] https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration
# [theme] https://github.com/catppuccin/fzf?tab=readme-ov-file#usage

if [ $# -ne 2 ]; then
  echo "Usage: $0 <flavour> <accent>"
  exit 1
fi

flavour="$1"
# accent="$2"

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

catppuccin_fzf_dir="${HOME}/.repos/catppuccin-fzf"

rm -rf "${catppuccin_fzf_dir}"

git clone -q --depth=1 \
  https://github.com/catppuccin/fzf.git \
  "${catppuccin_fzf_dir}"

"${root_dir}/scripts/update_bashrc.sh" "fzf" <<EOF
source "\${HOME}/.repos/catppuccin-fzf/themes/catppuccin-fzf-${flavour}.sh"
EOF

exit 0
