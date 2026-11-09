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

  install -D -m 644 \
    "${file}" \
    "${HOME}/.bashrc.d/${priority}-${package}.sh"
}
