#!/bin/bash
set -eu

# [theme] https://github.com/catppuccin/lazygit?tab=readme-ov-file#installation

if [ $# -ne 2 ]; then
  echo "Usage: $0 <flavour> <accent>"
  exit 1
fi

flavour="$1"
accent="$2"

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

lazygit_dir="${HOME}/.config/lazygit"
lazygit_theme="${flavour}-${accent}"

mkdir -p "${lazygit_dir}"

wget -qO \
  "${lazygit_dir}/${lazygit_theme}.yml" \
  "https://raw.githubusercontent.com/catppuccin/lazygit/refs/heads/main/themes-mergable/${flavour}/${accent}.yml"

"${root_dir}/scripts/update_bashrc.sh" "lazygit" <<EOF
export LG_CONFIG_FILE="\${HOME}/.config/lazygit/config.yml,\${HOME}/.config/lazygit/${lazygit_theme}.yml"
EOF

exit 0
