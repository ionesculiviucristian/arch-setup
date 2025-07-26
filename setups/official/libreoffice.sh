#!/bin/bash
set -eu

# https://github.com/catppuccin/libreoffice

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

libreoffice_theme_file=$(mktemp)
libreoffice_user_dir="${HOME}/.config/libreoffice/4/user"

_mkdir "${libreoffice_user_dir}/config"

download \
  "${libreoffice_user_dir}/config/catppuccin-mocha-mauve.soc" \
  https://raw.githubusercontent.com/catppuccin/libreoffice/refs/heads/main/themes/mocha/mauve/catppuccin-mocha-mauve.soc

download \
  "${libreoffice_theme_file}" \
  https://raw.githubusercontent.com/catppuccin/libreoffice/main/themes/mocha/mauve/catppuccin-mocha-mauve.xcu

if [ ! -f "${libreoffice_user_dir}/registrymodifications.xcu" ]; then
  {
    echo '<?xml version="1.0" encoding="UTF-8"?>'
    echo '<oor:items xmlns:oor="http://openoffice.org/2001/registry" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
    cat "${libreoffice_theme_file}"; echo
    echo '</oor:items>'
  } > "${libreoffice_user_dir}/registrymodifications.xcu"
else
  # shellcheck disable=SC2086
  sed -i \
    "s|<item oor:path=\"\/org.openoffice.Office.UI\/ColorScheme\/ColorSchemes\">.*<\/item>|$(cat ${libreoffice_theme_file})|" \
    "${libreoffice_user_dir}/registrymodifications.xcu"
fi

exit 0
