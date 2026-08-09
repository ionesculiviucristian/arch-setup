# shellcheck shell=bash

# @description Download a URL to a file.
# @arg $1 string URL to download
# @arg $2 string Path to save the download to
# @exitcode 1 Failed download
request::download() {
  local usage="Usage: request::download <url> <file>"
  local url=${1:-}
  local file=${2:-}

  if [ -z "${url}" ] || [ -z "${file}" ]; then
    log::error "${usage}"
    return 2
  fi

  log::debug "Downloading ${url} to ${file}"

  if ! wget -qO "${file}.part" "${url}"; then
    rm -f "${file}.part"
    return 1
  fi

  mv -f "${file}.part" "${file}"
}

# @description Download an archive and extract it.
# @arg $1 string Archive URL
# @arg $2 string Destination directory
# @exitcode * Failed download or extraction
request::extract() {
  local usage="Usage: request::extract <url> <path>"
  local url=${1:-}
  local path=${2:-}

  if [ -z "${url}" ] || [ -z "${path}" ]; then
    log::error "${usage}"
    return 2
  fi

  log::debug "Extracting ${url} to ${path}"

  local archive
  archive=$(mktemp)

  local status=0
  wget -qO "${archive}" "${url}" && bsdtar -xf "${archive}" -C "${path}" || status=$?

  rm -f "${archive}"
  return "${status}"
}
