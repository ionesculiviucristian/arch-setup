# shellcheck shell=bash

# @description Print the path of a profile.yml.
# @arg $1 string Profile folder name
# @internal
profile::_file() {
  local file="${arch_setup_dir:?}/profiles/$1/profile.yml"

  if [ -f "${file}" ]; then
    echo "${file}"
  fi
}

# @description Print the profiles a profile includes, depth first and each
# one only once, the profile itself last.
# @arg $1 string Profile folder name
# @arg $2 string Profiles already printed, space separated
# @exitcode 1 Unknown profile
# @internal
profile::_chain() {
  local machine=$1

  if [[ "${profile_chain_seen}" == *" ${machine} "* ]]; then
    return 0
  fi

  local file
  file=$(profile::_file "${machine}")

  if [ -z "${file}" ]; then
    log::error "Unknown profile ${machine}"
    return 1
  fi

  profile_chain_seen+="${machine} "

  local include

  while IFS= read -r include; do
    [ -n "${include}" ] || continue

    profile::_chain "${include}" || return 1
  done < <(yq -r '.includes // [] | .[]' "${file}")

  echo "${machine}"
}

# @description Print a profile and every profile it includes, the included
# ones first.
# @arg $1 string Profile folder name
# @exitcode 1 Unknown profile
profile::chain() {
  local usage="Usage: profile::chain <profile>"
  local machine=${1:-}

  if [ -z "${machine}" ]; then
    log::error "${usage}"
    return 2
  fi

  local profile_chain_seen=" "

  profile::_chain "${machine}"
}

# @description Run the scripts for a profile: export it, point
# arch_setup_dirs at the repositories of its chain, the last profile first,
# and load its environment.
# @arg $1 string Profile folder name
# @exitcode 1 Unknown profile
profile::use() {
  local usage="Usage: profile::use <profile>"
  local machine=${1:-}

  if [ -z "${machine}" ]; then
    log::error "${usage}"
    return 2
  fi

  local chain
  chain=$(profile::chain "${machine}") || return 1

  export ARCH_SETUP_PROFILE=${machine}

  local profile dir

  arch_setup_dirs=()

  while IFS= read -r profile; do
    dir="${arch_setup_dir:?}/profiles/${profile}"

    if [ -d "${dir}/repositories" ]; then
      arch_setup_dirs=("${dir}" "${arch_setup_dirs[@]}")
    fi
  done <<<"${chain}"

  arch_setup_dirs+=("${arch_setup_dir}")

  env::load
}

# @description Print the packages and drivers of a profile, highest
# priority first.
# @arg $1 string Path to the profile.yml
# @internal
profile::_entries() {
  yq -r '
    [(.packages // {}), (.drivers // {})] | map(to_entries) | flatten
    | map(select(.value.priority == "highest"))
      + map(select(.value.priority == "high"))
      + map(select((.value.priority // "normal") == "normal"))
    | .[].key
  ' "$1"
}

# @description Print a profile's package names of the given repository
# types; base also lists the fonts.
# @arg $1 string Profile folder name
# @arg $@ string Repository types: core, extra, multilib, aur or external
profile::packages_by_repository_type() {
  local usage="Usage: profile::packages_by_repository_type <profile> <repository type>..."

  if [ $# -lt 2 ] || [ -z "$1" ]; then
    log::error "${usage}"
    return 2
  fi

  local machine=$1
  shift
  local repository_types=" $* "
  local profile
  profile=$(profile::_file "${machine}")

  if [ -z "${profile}" ]; then
    return
  fi

  local entry pkg_dir yml

  {
    for entry in $(profile::_entries "${profile}"); do
      pkg_dir=$(package::_dir "${entry}")
      if [ -n "${pkg_dir}" ]; then
        echo "${pkg_dir}/package.yml"
      fi
    done

    if [ "${profile}" = "${arch_setup_dir:?}/profiles/base/profile.yml" ]; then
      printf '%s\n' "${arch_setup_dir}"/repositories/fonts/*.yml
    fi
  } | while read -r yml; do
    if [[ "${repository_types}" == *" $(package::repository_type "${yml}") "* ]]; then
      package::name "${yml}"
    fi
  done | sort -u
}

# @description Print the installed packages and drivers of every profile; an
# external package counts as installed, since pacman does not know it.
# @option --themes Only the entries with themes enabled
profile::installed_packages() {
  local filter="."

  if [ "${1:-}" = "--themes" ]; then
    filter="select(.value.themes)"
  fi

  local profile_file entry pkg_dir yml

  for profile_file in "${arch_setup_dir:?}"/profiles/*/profile.yml; do
    [ -f "${profile_file}" ] || continue
    yq -r "
      ((.packages // {}), (.drivers // {}))
      | to_entries[]
      | ${filter}
      | .key
    " "${profile_file}"
  done | sort -u | while read -r entry; do
    pkg_dir=$(package::_dir "${entry}")
    [ -n "${pkg_dir}" ] || continue

    yml="${pkg_dir}/package.yml"

    if [ "$(package::repository_type "${yml}")" = "external" ] ||
      pacman -Q "$(package::name "${yml}")" &>/dev/null; then
      echo "${entry}"
    fi
  done
}

# @description Run a package's script from every repository that has it,
# this repository first and the profiles that own the package after, so a
# profile adds to the shared script instead of replacing it.
# @arg $1 string Package or driver folder name
# @arg $2 string Script name
# @arg $@ string Arguments passed to the script (optional)
profile::run_script() {
  local usage="Usage: profile::run_script <package> <script name> [argument]..."
  local name=${1:-}
  local script_name=${2:-}

  if [ -z "${name}" ] || [ -z "${script_name}" ]; then
    log::error "${usage}"
    return 2
  fi
  shift 2

  local pkg_dir label logged=false dir script
  pkg_dir=$(package::_dir "${name}")
  label=${name}

  if [ -n "${pkg_dir}" ]; then
    label=$(yq -r '.label // ""' "${pkg_dir}/package.yml")
    [ -n "${label}" ] || label=${name}
  fi

  while IFS= read -r dir; do
    script="${dir}/${script_name}.sh"

    [ -x "${script}" ] || continue

    if [ "${logged}" = false ]; then
      log::info "  ${label}"
      logged=true
    fi

    log::debug "Running ${script}"
    "${script}" "$@"
  done < <(file::find --all --dir \
    "repositories/packages/${name}" "repositories/drivers/${name}" | tac)
}

# @description Run a script for every package of a profile, highest
# priority first.
# @arg $1 string Profile folder name
# @arg $2 string Script name: setup, setup-theme or install
profile::run_scripts() {
  local usage="Usage: profile::run_scripts <profile> <script name>"
  local machine=${1:-}
  local script_name=${2:-}

  if [ -z "${machine}" ] || [ -z "${script_name}" ]; then
    log::error "${usage}"
    return 2
  fi
  local profile
  profile=$(profile::_file "${machine}")

  if [ -z "${profile}" ]; then
    return
  fi

  local entry

  for entry in $(profile::_entries "${profile}"); do
    profile::run_script "${entry}" "${script_name}"
  done
}
