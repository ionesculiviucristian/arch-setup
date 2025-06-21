#!/bin/bash
set -eu

if [ $# -lt 1 ]; then
  echo "Usage: $0 <font-url>"
  exit 1
fi

URL="$1"

FONTS_DIR="${HOME}/.local/share/fonts"
mkdir -p "${FONTS_DIR}"

TMP_DIR=$(mktemp -d)
FILE_NAME=$(basename "${URL}")
FILE_PATH="${TMP_DIR}/${FILE_NAME}"

wget -qO "${FILE_PATH}" "${URL}"

case "${FILE_NAME}" in
  *.zip)
    unzip -q "${FILE_PATH}" -d "${TMP_DIR}"
    ;;
  *.tar.xz)
    tar -xf "${FILE_PATH}" -C "${TMP_DIR}"
    ;;
  *.tar.gz)
    tar -xzf "${FILE_PATH}" -C "${TMP_DIR}"
    ;;
  *)
    rm -rf "${TMP_DIR}"
    echo "Unsupported file type: ${FILE_NAME}"
    exit 1
    ;;
esac

find "${TMP_DIR}" -type f \( -iname "*.ttf" -o -iname "*.otf" \) -exec cp {} "${FONTS_DIR}" \;

rm -rf "${TMP_DIR}"
fc-cache -f > /dev/null
