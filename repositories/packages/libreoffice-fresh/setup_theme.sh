#!/bin/bash
set -eu

# [theme] https://github.com/catppuccin/libreoffice?tab=readme-ov-file#usage

if [ $# -ne 2 ]; then
  echo "Usage: $0 <flavour> <accent>"
  exit 1
fi

flavour="$1"
accent="$2"

libreoffice_user_dir="${HOME}/.config/libreoffice/4/user"
libreoffice_theme="catppuccin-${flavour}-${accent}"

mkdir -p "${libreoffice_user_dir}/config"

local_theme_file=$(mktemp)

wget -qO \
  "${libreoffice_user_dir}/config/${libreoffice_theme}.soc" \
  "https://raw.githubusercontent.com/catppuccin/libreoffice/refs/heads/main/themes/${flavour}/${accent}/${libreoffice_theme}.soc"

wget -qO \
  "${local_theme_file}" \
  "https://raw.githubusercontent.com/catppuccin/libreoffice/main/themes/${flavour}/${accent}/${libreoffice_theme}.xcu"

if [ ! -f "${libreoffice_user_dir}/registrymodifications.xcu" ]; then
  {
    echo '<?xml version="1.0" encoding="UTF-8"?>'
    echo '<oor:items xmlns:oor="http://openoffice.org/2001/registry" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
    cat "${local_theme_file}"
    echo
    echo '</oor:items>'
  } >"${libreoffice_user_dir}/registrymodifications.xcu"
else
  # shellcheck disable=SC2086
  sed -i \
    "s|<item oor:path=\"\/org.openoffice.Office.UI\/ColorScheme\/ColorSchemes\">.*<\/item>|$(cat ${local_theme_file})|" \
    "${libreoffice_user_dir}/registrymodifications.xcu"
fi

rm -f "${local_theme_file}"

exit 0
