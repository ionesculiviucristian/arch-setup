#!/bin/bash
set -eu

# [Theme] https://github.com/catppuccin/kde

# shellcheck disable=SC1091
source "./scripts/installer.sh"

catppuccin_kde_dir="${HOME}/.repos/catppuccin-fzf"
cursors_theme="catppuccin-mocha-mauve-cursors"
icons_dir="${HOME}/.local/share/icons"

rm -rf "${catppuccin_kde_dir}"
rm -rf "${HOME}/.local/share/kpackage/generic/Catppuccin-"*

git clone -q --depth=1 \
  https://github.com/catppuccin/kde \
  "${catppuccin_kde_dir}"

(
  cd "${catppuccin_kde_dir}"
  printf "1\n4\n2\ny\ny" | ./install.sh >/dev/null

  rm -rf "${icons_dir}/Catppuccin-"*
  rm -rf "${icons_dir}/icons/${cursors_theme}"

  # Use newer Catppuccin cursors
  sudo_extract_from_url \
    https://github.com/catppuccin/cursors/releases/download/v2.0.0/${cursors_theme}.zip \
    "${icons_dir}"
  
  if [ ! -L "${HOME}/.icons" ]; then
    ln -s "${icons_dir}" "${HOME}/.icons"
  fi

  plasma-apply-cursortheme "${cursors_theme}" >/dev/null
)

exit 0
