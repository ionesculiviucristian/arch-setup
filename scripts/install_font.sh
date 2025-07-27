#!/bin/bash
set -eu

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

url="$1"
name="${2:-"unknown"}"

fonts_dir="${HOME}/.local/share/fonts"
mkdir -p "${fonts_dir}"
tmp_dir=$(mktemp -d)

archive=$(basename "${url}")
archive_path="${tmp_dir}/${archive}"

wget -qO "${archive_path}" "${url}"

case "${archive}" in
  *.zip)
    unzip -q "${archive_path}" -d "${tmp_dir}"
    ;;
  *.tar.xz)
    tar -xf "${archive_path}" -C "${tmp_dir}"
    ;;
  *.tar.gz)
    tar -xzf "${archive_path}" -C "${tmp_dir}"
    ;;
  *)
    rm -rf "${tmp_dir}"
    echo "Error: Cannot extract contents from ${archive}"
    exit 1
    ;;
esac

inform_install "${name} font"
find "${tmp_dir}" -type f \( -iname "*.ttf" -o -iname "*.otf" \) -exec cp {} "${fonts_dir}" \;

rm -rf "${tmp_dir}"
fc-cache -f > /dev/null
