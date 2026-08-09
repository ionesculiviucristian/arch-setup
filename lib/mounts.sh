# shellcheck shell=bash

# @description Print the entries of a mounts.json group.
# @arg $1 string Group: system or onedrive
# @exitcode 1 No repository has a mounts.json
mounts::list() {
  local usage="Usage: mounts::list <group>"
  local key=${1:-}

  if [ -z "${key}" ]; then
    log::error "${usage}"
    return 2
  fi

  local file
  file=$(file::find "mounts.json")

  if [ -z "${file}" ]; then
    log::error "mounts.json not found in ${arch_setup_dirs[*]:?}"
    return 1
  fi

  yq -o=json -I=0 ".${key}[]" "${file}"
}

# @description Print a field of a mounts.json entry.
# @arg $1 string Entry from mounts::list
# @arg $2 string Field name, e.g. source or destination
mounts::field() {
  local usage="Usage: mounts::field <entry> <field>"
  local entry=${1:-}
  local field=${2:-}

  if [ -z "${entry}" ] || [ -z "${field}" ]; then
    log::error "${usage}"
    return 2
  fi

  echo "${entry}" | yq -p=json -r ".${field} // \"\""
}
