#!/bin/bash
set -eu

# https://github.com/catppuccin/kde

catppuccin_kde_dir="${HOME}/.repos/catppuccin-fzf"
icons_dir="${HOME}/.local/share/icons"

rm -rf "${catppuccin_kde_dir}"

git clone -q --depth=1 https://github.com/catppuccin/kde "${catppuccin_kde_dir}"

(
  cd "${catppuccin_kde_dir}"
  printf "1\n4\n2\ny\ny" | ./install.sh >/dev/null

  rm -rf "${icons_dir}/Catppuccin-Mocha-Dark-Cursors"
  rm -rf "${icons_dir}/Catppuccin-Mocha-Mauve-Cursors"

  # Use newer Catppuccin cursors
  rm -rf "${icons_dir}/icons/catppuccin-mocha-mauve-cursors"
  wget -qO- https://github.com/catppuccin/cursors/releases/download/v2.0.0/catppuccin-mocha-mauve-cursors.zip | bsdtar -xvf- -C "${icons_dir}"
  
  if [ ! -L "${HOME}/.icons" ]; then
    ln -s "${icons_dir}" "${HOME}/.icons"
  fi

  plasma-apply-cursortheme "catppuccin-mocha-mauve-cursors"
)

exit 0
