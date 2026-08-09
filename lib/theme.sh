# shellcheck shell=bash

# @description Print a value of the THEME from .env.
# @arg $1 string yq path in the theme file, e.g. .wallpapers.sddm
# @exitcode 1 THEME missing from .env
theme::get() {
  local usage="Usage: theme::get <yq path>"
  local path=${1:-}

  if [ -z "${path}" ]; then
    log::error "${usage}"
    return 2
  fi

  local theme
  theme=$(env::get "THEME") || return 1

  yq -r "${path}" "${arch_setup_dir:?}/themes/${theme}.yml"
}

# @description Apply the THEME from .env to the OS and the themed packages.
# @noargs
# @exitcode 1 At least one theme failed
theme::apply() {
  local flavour accent
  flavour=$(theme::get '.flavour')
  accent=$(theme::get '.accent')

  log::debug "Theme: ${flavour} ${accent}"

  local failed=()

  log::info "  OS"
  "${arch_setup_dir:?}/os/setup-theme.sh" "${flavour}" "${accent}" || failed+=("os")

  local pkg_dir script

  for pkg_dir in $(profile::installed_dirs --themes); do
    script="${pkg_dir}/setup-theme.sh"
    if [ -x "${script}" ]; then
      log::info "  $(yq -r '.label' "${pkg_dir}/package.yml")"
      "${script}" "${flavour}" "${accent}" || failed+=("${pkg_dir##*/}")
    fi
  done

  if [ ${#failed[@]} -gt 0 ]; then
    log::info "Failed themes: ${failed[*]}"
    return 1
  fi
}
