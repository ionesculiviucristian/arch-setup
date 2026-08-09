# shellcheck shell=bash

# @description Install a shell snippet in ~/.bashrc.d/.
# @option --package <name> Package name
# @option --priority <priority> Load order prefix
# @arg $1 string Path to the shell snippet to install (optional)
# @stdin Snippet content when no file is given
bash::install_bashrc() {
  local usage="Usage: bash::install_bashrc --package <name> --priority <priority> [file]"
  local package=""
  local priority=""
  local file="/dev/stdin"

  while [ $# -gt 0 ]; do
    case "$1" in
    --package)
      [ $# -ge 2 ] || {
        log::error "${usage}"
        return 2
      }
      package=$2
      shift 2
      ;;
    --priority)
      [ $# -ge 2 ] || {
        log::error "${usage}"
        return 2
      }
      priority=$2
      shift 2
      ;;
    -*)
      log::error "${usage}"
      return 2
      ;;
    *)
      [ $# -eq 1 ] || {
        log::error "${usage}"
        return 2
      }
      file=$1
      shift
      ;;
    esac
  done

  if [ -z "${package}" ] || [ -z "${priority}" ]; then
    log::error "${usage}"
    return 2
  fi

  local bashrc_file="${HOME}/.bashrc"
  local bashrc_dir="${HOME}/.bashrc.d"

  # shellcheck disable=SC2016
  local loader='for f in "${HOME}"/.bashrc.d/*.sh; do [ -r "${f}" ] && . "${f}"; done; unset f'

  grep -qxF "${loader}" "${bashrc_file}" || printf '\n%s\n' "${loader}" >>"${bashrc_file}"

  install -D -m 644 \
    "${file}" \
    "${bashrc_dir}/${priority}-${package}.sh"
}
