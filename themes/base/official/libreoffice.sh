#!/bin/bash
set -eu

# shellcheck source=../../../setups/base/_config.sh
source "./setups/base/_config.sh"

install_libreoffice_theme() {
  mkdir -p "${libreoffice_user_dir}/config"

  local libreoffice_theme_file
  libreoffice_theme_file=$(mktemp)

  wget -qO \
    "${libreoffice_user_dir}/config/${libreoffice_theme}.soc" \
    "https://raw.githubusercontent.com/catppuccin/libreoffice/refs/heads/main/themes/mocha/mauve/${libreoffice_theme}.soc"

  wget -qO \
    "${libreoffice_theme_file}" \
    "https://raw.githubusercontent.com/catppuccin/libreoffice/main/themes/mocha/mauve/${libreoffice_theme}.xcu"

  if [ ! -f "${libreoffice_user_dir}/registrymodifications.xcu" ]; then
    {
      echo '<?xml version="1.0" encoding="UTF-8"?>'
      echo '<oor:items xmlns:oor="http://openoffice.org/2001/registry" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
      cat "${libreoffice_theme_file}"
      echo
      echo '</oor:items>'
    } >"${libreoffice_user_dir}/registrymodifications.xcu"
  else
    # shellcheck disable=SC2086
    sed -i \
      "s|<item oor:path=\"\/org.openoffice.Office.UI\/ColorScheme\/ColorSchemes\">.*<\/item>|$(cat ${libreoffice_theme_file})|" \
      "${libreoffice_user_dir}/registrymodifications.xcu"
  fi

  rm -f "${libreoffice_theme_file}"
}
