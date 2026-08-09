#!/bin/bash
set -eu

# @see [theme](https://github.com/catppuccin/libreoffice?tab=readme-ov-file#usage)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

if [ $# -ne 2 ]; then
  log::error "Usage: $0 <flavour> <accent>"
  exit 2
fi

flavour="$1"
accent="$2"

libreoffice_config_dir="${HOME}/.config/libreoffice/4/user"
libreoffice_theme="catppuccin-${flavour}-${accent}"
registry_file="${libreoffice_config_dir}/registrymodifications.xcu"
catppuccin_scheme_item='^<item oor:path="/org.openoffice.Office.UI/ColorScheme/ColorSchemes"><node oor:name="Catppuccin '

mkdir -p "${libreoffice_config_dir}/config"

local_theme_file=$(mktemp)
trap 'rm -f "${local_theme_file}"' EXIT

request::download \
  "https://raw.githubusercontent.com/catppuccin/libreoffice/refs/heads/main/themes/${flavour}/${accent}/${libreoffice_theme}.soc" \
  "${libreoffice_config_dir}/config/${libreoffice_theme}.soc"

request::download \
  "https://raw.githubusercontent.com/catppuccin/libreoffice/refs/heads/main/themes/${flavour}/${accent}/${libreoffice_theme}.xcu" \
  "${local_theme_file}"

if [ ! -f "${registry_file}" ]; then
  {
    echo '<?xml version="1.0" encoding="UTF-8"?>'
    echo '<oor:items xmlns:oor="http://openoffice.org/2001/registry" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
    cat "${local_theme_file}"
    echo
    echo '</oor:items>'
  } >"${registry_file}"
else
  sed -i "\|${catppuccin_scheme_item}|d" "${registry_file}"

  file::replace_text \
    '^</oor:items>$' \
    "$(sed 's/[&\\]/\\&/g' "${local_theme_file}")\n</oor:items>" \
    "${registry_file}"
fi

exit 0
