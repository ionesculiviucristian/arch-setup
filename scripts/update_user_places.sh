#!/bin/bash
set -eu

path="$1"
title="$2"

ID=$(date +%s)
user_places_file="${HOME}/.local/share/user-places.xbel"

[ ! -f "${user_places_file}" ] && echo '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE xbel><xbel version="1.0"></xbel>' > "${user_places_file}"

if grep -q "<title>${title}</title>" "${user_places_file}"; then
  exit 0
fi

sed -i "/<\/xbel>/i\\
 <bookmark href=\"file://${path}\">\\
  <title>${title}</title>\\
  <info>\\
   <metadata owner=\"http://freedesktop.org\">\\
    <bookmark:icon name=\"folder\"/>\\
   </metadata>\\
   <metadata owner=\"http://www.kde.org\">\\
    <ID>${ID}</ID>\\
    <isSystemItem>false</isSystemItem>\\
   </metadata>\\
  </info>\\
 </bookmark>" "${user_places_file}"

exit 0
