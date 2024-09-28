#!/bin/bash
set -eu

path="$1"
title="$2"
id=$(date +%s)

if [ -z "${path}" ]; then
  echo "Error: Path is required"
  exit 1
fi

if [ -z "${title}" ]; then
  echo "Error: Title is required"
  exit 1
fi

user_places_file="${HOME}/.local/share/user-places.xbel"

if [ ! -f "${user_places_file}" ]; then 
  echo '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE xbel><xbel version="1.0"></xbel>' > "${user_places_file}"
fi

if xmlstarlet sel -t -v "//title[text() = '${title}']" "${user_places_file}" | grep -q .; then
  exit 0
fi

xmlstarlet ed --inplace \
  -s "/xbel" -t elem -n "bookmark" -v "" \
  "${user_places_file}"

count=$(xmlstarlet sel -t -v "count(//bookmark)" "${user_places_file}")

xmlstarlet ed --inplace \
  -i "//bookmark[${count}]" -t attr -n "href" -v "file://${path}" \
  -s "//bookmark[${count}]" -t elem -n "title" -v "${title}" \
  -s "//bookmark[${count}]" -t elem -n "info" -v "" \
  -s "//bookmark[${count}]/info" -t elem -n "metadata" -v "" \
  -i "//bookmark[${count}]/info/metadata[1]" -t attr -n "owner" -v "http://freedesktop.org" \
  -s "//bookmark[${count}]/info/metadata[1]" -t elem -n "bookmark:icon" -v "" \
  -i "//bookmark[${count}]/info/metadata[1]/bookmark:icon" -t attr -n "name" -v "folder" \
  -s "//bookmark[${count}]/info" -t elem -n "metadata" -v "" \
  -i "//bookmark[${count}]/info/metadata[2]" -t attr -n "owner" -v "http://www.kde.org" \
  -s "//bookmark[${count}]/info/metadata[2]" -t elem -n "ID" -v "${id}" \
  -s "//bookmark[${count}]/info/metadata[2]" -t elem -n "isSystemItem" -v "false" \
  "${user_places_file}"

exit 0
