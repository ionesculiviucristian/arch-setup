# shellcheck shell=bash

# @description Print paths from the first repository that has one, the
# repositories being searched in the order of arch_setup_dirs and the paths
# in the order they are given; a path can be a glob.
# @option --all Print every match instead of only the first one
# @option --dir Match directories instead of files
# @arg $@ string Paths relative to a repository root, e.g. mounts.json
file::find() {
  local usage="Usage: file::find [--all] [--dir] <path>..."
  local all=false
  local dirs=false

  while [ $# -gt 0 ]; do
    case "$1" in
    --all)
      all=true
      shift
      ;;
    --dir)
      dirs=true
      shift
      ;;
    -*)
      log::error "${usage}"
      return 2
      ;;
    *)
      break
      ;;
    esac
  done

  if [ $# -eq 0 ]; then
    log::error "${usage}"
    return 2
  fi

  local dir path match

  for dir in "${arch_setup_dirs[@]:?}"; do
    for path in "$@"; do
      while IFS= read -r match; do
        if [ "${dirs}" = true ]; then
          [ -d "${match}" ] || continue
        else
          [ -f "${match}" ] || continue
        fi

        echo "${match}"
        [ "${all}" = true ] || return 0
      done < <(compgen -G "${dir}/${path}" || true)
    done
  done
}

# @description Replace text in a file.
# @option --sudo Run as root
# @option --range <address> Limit to a sed address range
# @arg $1 string sed regex to find
# @arg $2 string Replacement text
# @arg $3 string Path to the file to edit
# @exitcode 1 Pattern not found
file::replace_text() {
  local usage="Usage: file::replace_text [--sudo] [--range <sed address>] <pattern> <replacement> <file>"
  local run=()
  local range=""

  while [ $# -gt 0 ]; do
    case "$1" in
    --sudo)
      run=(sudo)
      shift
      ;;
    --range)
      range=$2
      shift 2
      ;;
    *)
      break
      ;;
    esac
  done

  if [ $# -ne 3 ]; then
    log::error "${usage}"
    return 2
  fi

  local pattern=$1
  local replacement=$2
  local file=$3
  local delimiter=$'\x01'

  local content
  content=$("${run[@]}" sed -n "${range}p" "${file}")

  if ! grep -q -- "${pattern}" <<<"${content}" &&
    ! grep -qxF -- "${replacement}" <<<"${content}"; then
    log::error "Pattern '${pattern}' not found in ${file}"
    return 1
  fi

  "${run[@]}" sed -i \
    "${range}s${delimiter}${pattern}${delimiter}${replacement}${delimiter}" \
    "${file}"
}

# @description Insert a line after the first line matching a regex, unless
# the line is already there.
# @option --sudo Run as root
# @arg $1 string sed regex of the anchor line
# @arg $2 string Line to insert
# @arg $3 string Path to the file to edit
# @exitcode 1 Anchor not found
file::insert_after() {
  local usage="Usage: file::insert_after [--sudo] <anchor> <line> <file>"
  local run=()

  if [ "${1:-}" = "--sudo" ]; then
    run=(sudo)
    shift
  fi

  if [ $# -ne 3 ]; then
    log::error "${usage}"
    return 2
  fi

  local anchor=$1
  local line=$2
  local file=$3
  local delimiter=$'\x01'

  if "${run[@]}" grep -qxF -- "${line}" "${file}"; then
    return 0
  fi

  if ! "${run[@]}" grep -q -- "${anchor}" "${file}"; then
    log::error "Anchor '${anchor}' not found in ${file}"
    return 1
  fi

  "${run[@]}" sed -i \
    "0,\\${delimiter}${anchor}${delimiter}{\\${delimiter}${anchor}${delimiter}a\\
${line//\\/\\\\}
}" \
    "${file}"
}
