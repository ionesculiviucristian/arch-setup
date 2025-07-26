#!/bin/bash
set -eu

# https://github.com/catppuccin/kde

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

catppuccin_kde_dir="${HOME}/.repos/catppuccin-fzf"
icons_dir="${HOME}/.local/share/icons"

_rmdir "${catppuccin_kde_dir}"

git clone -q --depth=1 https://github.com/catppuccin/kde "${catppuccin_kde_dir}"

_rmdir "${HOME}/.local/share/kpackage/generic/Catppuccin-Mocha-Mauve"

(
  cd "${catppuccin_kde_dir}"
  printf "1\n4\n2\ny\ny" | ./install.sh 2>&1 | tee -a "./install.log" >/dev/null

  _rmdir "${icons_dir}/Catppuccin-Mocha-Dark-Cursors"
  _rmdir "${icons_dir}/Catppuccin-Mocha-Mauve-Cursors"

  # Use newer Catppuccin cursors
  _rmdir "${icons_dir}/icons/catppuccin-mocha-mauve-cursors"
  wget -qO- https://github.com/catppuccin/cursors/releases/download/v2.0.0/catppuccin-mocha-mauve-cursors.zip | bsdtar -xvf- -C "${icons_dir}" 2>&1 | tee -a "./install.log" >/dev/null
  
  if [ ! -L "${HOME}/.icons" ]; then
    ln -s "${icons_dir}" "${HOME}/.icons"
  fi

  plasma-apply-cursortheme "catppuccin-mocha-mauve-cursors" 2>&1 | tee -a "./install.log" >/dev/null
)

exit 0
