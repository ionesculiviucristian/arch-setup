#!/bin/bash
set -eu

lazygit_dir="${HOME}/.config/lazygit"

mkdir -p "${lazygit_dir}"

cp \
  "./configs/.config/lazygit/config.yml" \
  "${lazygit_dir}/config.yml"

wget -qO - https://raw.githubusercontent.com/catppuccin/lazygit/main/themes/mocha/mauve.yml \
  | yq eval-all --inplace 'select(fileIndex == 0) as $config | select(fileIndex == 1) as $res | $config | .gui.theme = ($res.theme) | .gui.authorColors = ($res.authorColors)' "${lazygit_dir}/config.yml" -

exit 0
