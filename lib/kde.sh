# shellcheck shell=bash

# @description Add a folder to the KDE Places panel.
# @arg $1 string Folder path
# @arg $2 string Title shown in Places
kde::add_user_place() {
  local usage="Usage: kde::add_user_place <path> <title>"
  local path=${1:-}
  local title=${2:-}

  if [ -z "${path}" ] || [ -z "${title}" ]; then
    log::error "${usage}"
    return 2
  fi

  local file="${HOME}/.local/share/user-places.xbel"

  if [ ! -f "${file}" ]; then
    NAMESPACE="http://www.freedesktop.org/standards/desktop-bookmarks" \
      yq -n -o xml '
        .xbel."+@xmlns:bookmark" = strenv(NAMESPACE)
        | .xbel."+@version" = "1.0"
      ' | install -D -m 644 /dev/stdin "${file}"
  fi

  local existing
  existing=$(PLACE_TITLE=${title} yq -p xml -o json -I 0 '
    [.xbel.bookmark]
    | flatten
    | map(select(.title == strenv(PLACE_TITLE)))
    | length
  ' "${file}")

  if [ "${existing}" -gt 0 ]; then
    return 0
  fi

  PLACE_HREF="file://${path}" PLACE_TITLE=${title} PLACE_ID=$(date +%s) \
    yq -p xml -o xml -i '
      .xbel.bookmark = ([.xbel.bookmark] | flatten | map(select(. != null)))
        + [{
          "+@href": strenv(PLACE_HREF),
          "title": strenv(PLACE_TITLE),
          "info": {
            "metadata": [
              {
                "+@owner": "http://freedesktop.org",
                "bookmark:icon": {"+@name": "folder"}
              },
              {
                "+@owner": "http://www.kde.org",
                "ID": strenv(PLACE_ID),
                "isSystemItem": "false"
              }
            ]
          }
        }]
    ' "${file}"
}
