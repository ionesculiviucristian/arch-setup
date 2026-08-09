#!/bin/bash
set -eu

# [theme] https://github.com/catppuccin/libreoffice?tab=readme-ov-file#usage

if [ $# -ne 2 ]; then
  echo "Usage: $0 <flavour> <accent>"
  exit 1
fi

flavour="$1"
accent="$2"

libreoffice_config_dir="${HOME}/.config/libreoffice/4/user"
libreoffice_theme="catppuccin-${flavour}-${accent}"

mkdir -p "${libreoffice_config_dir}/config"

local_theme_file=$(mktemp)

wget -qO \
  "${libreoffice_config_dir}/config/${libreoffice_theme}.soc" \
  "https://raw.githubusercontent.com/catppuccin/libreoffice/refs/heads/main/themes/${flavour}/${accent}/${libreoffice_theme}.soc"

wget -qO \
  "${local_theme_file}" \
  "https://raw.githubusercontent.com/catppuccin/libreoffice/main/themes/${flavour}/${accent}/${libreoffice_theme}.xcu"

if [ ! -f "${libreoffice_config_dir}/registrymodifications.xcu" ]; then
  {
    echo '<?xml version="1.0" encoding="UTF-8"?>'
    echo '<oor:items xmlns:oor="http://openoffice.org/2001/registry" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
    cat "${local_theme_file}"
    echo
    echo '</oor:items>'
  } >"${libreoffice_config_dir}/registrymodifications.xcu"
else
  echo >>"${local_theme_file}"
  sed -i \
    -e '\|^<item oor:path="/org.openoffice.Office.UI/ColorScheme/ColorSchemes">|{' \
    -e "r ${local_theme_file}" \
    -e 'd' \
    -e '}' \
    "${libreoffice_config_dir}/registrymodifications.xcu"
fi

rm -f "${local_theme_file}"

exit 0
