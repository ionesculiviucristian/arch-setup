#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Utility functions for the per-package system.
# Source this file from install/update scripts.
#
# Structure:
#   profiles/<machine>.yml   - lists packages/drivers per machine
#   repositories/packages/*  - package definitions and scripts
#   repositories/drivers/*   - driver definitions and scripts

# Resolve a package directory from repositories.
# Usage: _resolve_pkg_dir <name>
_resolve_pkg_dir() {
  local name=$1

  for base in "${root_dir}/repositories/packages" "${root_dir}/repositories/drivers"; do
    if [ -d "${base}/${name}" ]; then
      echo "${base}/${name}"
      return
    fi
  done
}

# Get package names by repository for a given machine profile.
# Usage: get_packages_by_repo <machine> <repo...>
# Example: get_packages_by_repo base core extra
get_packages_by_repo() {
  local machine=$1
  shift
  local repos=("$@")
  local profile="${root_dir}/profiles/${machine}.yml"

  if [ ! -f "${profile}" ]; then
    return
  fi

  local entries
  entries=$(yq -r '(.packages // [])[] , (.drivers // [])[]' "${profile}")

  for entry in ${entries}; do
    local pkg_dir
    pkg_dir=$(_resolve_pkg_dir "${entry}")
    [ -n "${pkg_dir}" ] || continue

    local yml="${pkg_dir}/package.yml"
    [ -f "${yml}" ] || continue

    local repo
    repo=$(yq -r '.repository' "${yml}")
    local name
    name=$(yq -r '.name' "${yml}")

    for target_repo in "${repos[@]}"; do
      if [[ "${repo}" == "${target_repo}" ]]; then
        echo "${name}"
        break
      fi
    done
  done | sort -u
}

# Run a script (setup.sh, setup_theme.sh, install.sh) for each package that has one.
# Usage: run_package_scripts <machine> <script_name>
# Example: run_package_scripts base setup
run_package_scripts() {
  local machine=$1
  local script_name=$2
  local profile="${root_dir}/profiles/${machine}.yml"

  if [ ! -f "${profile}" ]; then
    return
  fi

  local entries
  entries=$(yq -r '(.packages // [])[] , (.drivers // [])[]' "${profile}")

  for entry in ${entries}; do
    local pkg_dir
    pkg_dir=$(_resolve_pkg_dir "${entry}")
    [ -n "${pkg_dir}" ] || continue

    local script="${pkg_dir}/${script_name}.sh"
    if [ -x "${script}" ]; then
      local label
      label=$(yq -r '.label' "${pkg_dir}/package.yml" 2>/dev/null || echo "${entry}")
      info "  ${label}" && "${script}"
    fi
  done
}

# Run a script for a specific package only (by directory name).
# Usage: run_package_script <package_dir_name> <script_name>
# Example: run_package_script docker setup
run_package_script() {
  local pkg_name=$1
  local script_name=$2

  local pkg_dir
  pkg_dir=$(_resolve_pkg_dir "${pkg_name}")
  [ -n "${pkg_dir}" ] || return

  local script="${pkg_dir}/${script_name}.sh"
  if [ -x "${script}" ]; then
    "${script}"
  fi
}
