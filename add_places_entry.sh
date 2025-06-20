#!/bin/bash
set -eu

PLACE_PATH="$1"
PLACE_NAME="$2"
ID=$(date +%s)
PLACES_FILE="${HOME}/.local/share/user-places.xbel"

[ ! -f "${PLACES_FILE}" ] && echo '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE xbel><xbel version="1.0"></xbel>' > "${PLACES_FILE}"

sed -i "/<\/xbel>/i\\
 <bookmark href=\"file://${PLACE_PATH}\">\\
  <title>${PLACE_NAME}</title>\\
  <info>\\
   <metadata owner=\"http://freedesktop.org\">\\
    <bookmark:icon name=\"folder\"/>\\
   </metadata>\\
   <metadata owner=\"http://www.kde.org\">\\
    <ID>${ID}</ID>\\
    <isSystemItem>false</isSystemItem>\\
   </metadata>\\
  </info>\\
 </bookmark>" "${PLACES_FILE}"
