#!/bin/bash
set -eu

url="$1"

FONTS_DIR="${HOME}/.local/share/fonts"
mkdir -p "${FONTS_DIR}"
TMP_DIR=$(mktemp -d)

archive=$(basename "${url}")
archive_path="${TMP_DIR}/${archive}"

wget -qO "${archive_path}" "${url}"

case "${archive}" in
  *.zip)
    unzip -q "${archive_path}" -d "${TMP_DIR}"
    ;;
  *.tar.xz)
    tar -xf "${archive_path}" -C "${TMP_DIR}"
    ;;
  *.tar.gz)
    tar -xzf "${archive_path}" -C "${TMP_DIR}"
    ;;
  *)
    rm -rf "${TMP_DIR}"
    echo "Error: Cannot extract contents from ${archive}"
    exit 1
    ;;
esac

find "${TMP_DIR}" -type f \( -iname "*.ttf" -o -iname "*.otf" \) -exec cp {} "${FONTS_DIR}" \;

rm -rf "${TMP_DIR}"
fc-cache -f > /dev/null
