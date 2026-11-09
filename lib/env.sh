# shellcheck shell=bash

# @description Print a variable from the .env of every repository, this one
# first and the ones installed on top after, so they can override it.
# @arg $1 string Variable name
# @exitcode 1 Variable missing from every .env
env::get() {
  local usage="Usage: env::get <name>"
  local name=${1:-}

  if [ -z "${name}" ]; then
    log::error "${usage}"
    return 2
  fi

  local value
  value=$(
    local file

    while IFS= read -r file; do
      # shellcheck source=SCRIPTDIR/../.env.example
      source "${file}"
    done < <(file::find --all ".env" | tac)

    echo "${!name:-}"
  )

  if [ -z "${value}" ]; then
    log::error "${name} missing from the .env of ${arch_setup_dirs[*]:?}"
    return 1
  fi

  echo "${value}"
}
