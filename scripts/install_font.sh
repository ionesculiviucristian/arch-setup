#!/bin/bash
set -eu

url="$1"

if [ -z "${url}" ]; then
  echo "Error: URL is required"
  exit 1
fi

tmp_dir=$(mktemp -d)
archive=$(basename "${url}")
archive_path="${tmp_dir}/${archive}"
fonts_dir="${HOME}/.local/share/fonts"

mkdir -p "${fonts_dir}"

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

find "${tmp_dir}" -type f \( -iname "*.ttf" -o -iname "*.otf" \) -exec cp {} "${fonts_dir}" \;

rm -rf "${tmp_dir}"

fc-cache -f >/dev/null
