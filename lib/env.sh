# shellcheck shell=bash

# @description Load the .env of this repository and, when
# ARCH_SETUP_PROFILE is set, the .env of that profile on top of it.
# @noargs
env::load() {
  arch_setup_env_files=("${arch_setup_dir:?}/.env")

  if [ -n "${ARCH_SETUP_PROFILE:-}" ]; then
    arch_setup_env_files+=(
      "${arch_setup_dir}/profiles/${ARCH_SETUP_PROFILE}/.env"
    )
  fi

  local file

  for file in "${arch_setup_env_files[@]}"; do
    if [ -f "${file}" ]; then
      # shellcheck source=SCRIPTDIR/../.env.example
      source "${file}"
    fi
  done
}

# @description Print a variable loaded by env::load.
# @arg $1 string Variable name
# @exitcode 1 Variable missing or empty
env::get() {
  local usage="Usage: env::get <name>"
  local name=${1:-}

  if [ -z "${name}" ]; then
    log::error "${usage}"
    return 2
  fi

  if [ -z "${!name:-}" ]; then
    log::error "${name} missing from ${arch_setup_env_files[*]:?}"
    return 1
  fi

  printf '%s\n' "${!name}"
}
