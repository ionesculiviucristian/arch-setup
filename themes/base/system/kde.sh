#!/bin/bash
set -eu

# shellcheck source=../../../setups/base/_config.sh
source "./setups/base/_config.sh"

# shellcheck disable=SC1091
source "./scripts/installer.sh"

install_kde_theme() {
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
}
