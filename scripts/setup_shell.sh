#!/bin/bash
set -eu

# Usage: setup_shell.sh --package <name> --priority <priority> [file]
# Copies <file> (or stdin) to ~/.bashrc.d/<priority>-<name>.sh
# Files are sourced in lexical order, so <priority> controls load order.

usage() {
  echo "Usage: $0 --package <name> --priority <priority> [file]"
  exit 1
}

package=""
priority=""
file="-"

while [ $# -gt 0 ]; do
  case "$1" in
  --package)
    package=${2:-}
    shift 2 || usage
    ;;
  --priority)
    priority=${2:-}
    shift 2 || usage
    ;;
  -*)
    usage
    ;;
  *)
    [ $# -eq 1 ] || usage
    file=$1
    shift
    ;;
  esac
done

if [ -z "${package}" ] || [ -z "${priority}" ]; then
  usage
fi

bashrc_file="${HOME}/.bashrc"
bashrc_dir="${HOME}/.bashrc.d"

# shellcheck disable=SC2016
loader='for f in "${HOME}"/.bashrc.d/*.sh; do [ -r "${f}" ] && . "${f}"; done; unset f'

mkdir -p "${bashrc_dir}"

grep -qxF "${loader}" "${bashrc_file}" || printf '\n%s\n' "${loader}" >>"${bashrc_file}"

cat -- "${file}" >"${bashrc_dir}/${priority}-${package}.sh"

exit 0
