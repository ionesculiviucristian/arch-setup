# shellcheck shell=bash

# @description Print the path of a profile.yml, from the first repository
# that has it.
# @arg $1 string Profile folder name
# @internal
profile::_file() {
  local dir file

  for dir in "${arch_setup_dirs[@]:?}"; do
    file="${dir}/profiles/$1/profile.yml"

    if [ -f "${file}" ]; then
      echo "${file}"
      return
    fi
  done
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
      if [ -n "${pkg_dir}" ] && [ -f "${pkg_dir}/package.yml" ]; then
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

# @description Print the folders of the installed packages and drivers of
# every profile of every repository; an external package counts as
# installed, since pacman does not know it.
# @option --themes Only the entries with themes enabled
profile::installed_dirs() {
  local filter="."

  if [ "${1:-}" = "--themes" ]; then
    filter="select(.value.themes)"
  fi

  local dir profile_file entry pkg_dir

  for dir in "${arch_setup_dirs[@]:?}"; do
    for profile_file in "${dir}"/profiles/*/profile.yml; do
      [ -f "${profile_file}" ] || continue
      yq -r "((.packages // {}), (.drivers // {})) | to_entries[] | ${filter} | .key" "${profile_file}"
    done
  done | sort -u | while read -r entry; do
    pkg_dir=$(package::_dir "${entry}")
    [ -n "${pkg_dir}" ] || continue

    if [ "$(package::repository_type "${pkg_dir}/package.yml")" = "external" ] ||
      pacman -Q "$(package::name "${pkg_dir}/package.yml")" &>/dev/null; then
      echo "${pkg_dir}"
    fi
  done
}

# @description Run a package's script, when the package has it.
# @arg $1 string Package, driver or profile package folder
# @arg $2 string Script name
profile::run_script() {
  local script="$1/$2.sh"

  [ -x "${script}" ] || return 0

  local label
  label=$(yq -r '.label' "$1/package.yml" 2>/dev/null || basename "$1")

  log::info "  ${label}"
  log::debug "Running ${script}"
  "${script}"
}

# @description Run a script for every package of a profile, highest
# priority first, then the scripts the profile itself owns in
# profiles/<name>/packages/<package>/, which may target a package of
# another profile, so a base package can be tuned per machine.
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

  local entry pkg_dir dir override_dir

  for entry in $(profile::_entries "${profile}"); do
    pkg_dir=$(package::_dir "${entry}")
    [ -n "${pkg_dir}" ] || continue

    profile::run_script "${pkg_dir}" "${script_name}"
  done

  for dir in "${arch_setup_dirs[@]:?}"; do
    for override_dir in "${dir}/profiles/${machine}/packages"/*/; do
      [ -d "${override_dir}" ] || continue

      profile::run_script "${override_dir%/}" "${script_name}"
    done
  done
}
