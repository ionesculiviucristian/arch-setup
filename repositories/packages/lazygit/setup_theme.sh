#!/bin/bash
set -eu

# [theme] https://github.com/catppuccin/lazygit?tab=readme-ov-file#installation

if [ $# -ne 2 ]; then
  echo "Usage: $0 <flavour> <accent>"
  exit 1
fi

flavour="$1"
accent="$2"

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

lazygit_config_dir="${HOME}/.config/lazygit"
lazygit_theme="${flavour}-${accent}"

mkdir -p "${lazygit_config_dir}"

wget -qO \
  "${lazygit_config_dir}/${lazygit_theme}.yml" \
  "https://raw.githubusercontent.com/catppuccin/lazygit/refs/heads/main/themes-mergable/${flavour}/${accent}.yml"

"${root_dir}/scripts/setup_shell.sh" \
  --package "lazygit" \
  --priority "50" \
  <<<"export LG_CONFIG_FILE=\"\${HOME}/.config/lazygit/config.yml,\${HOME}/.config/lazygit/${lazygit_theme}.yml\""

exit 0
