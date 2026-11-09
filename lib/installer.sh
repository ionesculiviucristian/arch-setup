# shellcheck shell=bash

installer_phases=()
installer_themes=false
installer_start=${SECONDS}

# @description Send stdout and stderr to <prefix>_<name>.log and
# <prefix>_errors_<name>.log in the root of this repository, and debug
# messages on fd 4 to <prefix>_<name>.log.
# @arg $1 string Log prefix, e.g. install or update
# @arg $2 string Log name, e.g. the profile
installer::redirect_logs() {
  local usage="Usage: installer::redirect_logs <prefix> <name>"
  local prefix=${1:-}
  local name=${2:-}

  if [ -z "${prefix}" ] || [ -z "${name}" ]; then
    log::error "${usage}"
    return 2
  fi

  local dir="${arch_setup_dir:?}"

  exec 1>"${dir}/${prefix}_${name}.log"
  exec 2>"${dir}/${prefix}_errors_${name}.log"
  exec 4>&1

  log::debug "Logs: ${dir}/${prefix}_${name}.log, ${dir}/${prefix}_errors_${name}.log"
}

# @description Install the packages needed by the scripts.
# @noargs
installer::install_requirements() {
  local packages=()
  local yml

  for yml in "${arch_setup_dir:?}"/repositories/requirements/*.yml; do
    packages+=("$(basename "${yml}" .yml)")
  done

  sudo pacman -Syu --needed --noconfirm "${packages[@]}" >/dev/null
}

# @description Start an installation: read the phases, redirect the logs,
# allow sudo without a password, hold the kernels and install the
# requirements.
# @arg $1 string Profile folder name
# @arg $@ string Phases: pre, packages, external, aur, setups, resources,
# themes, and --themes, --debug (optional, default: all but themes)
installer::start() {
  local usage="Usage: install.sh [profile] [pre|packages|external|aur|setups|resources|themes...] [--themes] [--debug]"
  local profile=${1:-}

  if [ -z "${profile}" ]; then
    log::error "${usage}"
    return 2
  fi
  shift

  profile::use "${profile}" || return 1

  local arg

  installer_phases=()
  installer_themes=false

  for arg in "$@"; do
    case "${arg}" in
    --themes) installer_themes=true ;;
    --debug) export ARCH_SETUP_DEBUG=1 ;;
    pre | packages | external | aur | setups | resources | themes)
      installer_phases+=("${arg}")
      ;;
    *)
      log::error "${usage}"
      return 2
      ;;
    esac
  done

  log::debug "Profile: ${profile}, phases: ${installer_phases[*]:-all}, themes: ${installer_themes}"

  installer::redirect_logs install "${profile}"

  trap 'sudo sed -i "/# arch-setup$/d" /etc/pacman.conf
    sudoers::disable_passwordless' EXIT

  installer_start=${SECONDS}

  log::info "Starting installation..."

  sudoers::enable_passwordless

  local kernels=()
  local kernel

  for kernel in linux linux-lts; do
    if pacman -Q "${kernel}" &>/dev/null; then
      kernels+=("${kernel}" "${kernel}-headers")
    fi
  done

  if [ ${#kernels[@]} -gt 0 ]; then
    log::debug "Holding kernels: ${kernels[*]}"
    file::insert_after --sudo \
      '^\[options\]' \
      "IgnorePkg = ${kernels[*]} # arch-setup" \
      "/etc/pacman.conf"
  fi

  installer::install_requirements

  local example

  while IFS= read -r example; do
    if [ ! -f "${example%.example}" ]; then
      cp "${example}" "${example%.example}"
    fi
  done < <(file::find --all ".env.example")
}

# @description Check if a phase runs: all of them when none was given,
# themes only with --themes or by name.
# @arg $1 string Phase name
installer::phase_enabled() {
  local usage="Usage: installer::phase_enabled <phase>"
  local name=${1:-}

  if [ -z "${name}" ]; then
    log::error "${usage}"
    return 2
  fi

  if [ "${name}" = "themes" ] && [ "${installer_themes}" = true ]; then
    return 0
  fi

  if [ ${#installer_phases[@]} -eq 0 ]; then
    [ "${name}" != "themes" ]
    return
  fi

  [[ " ${installer_phases[*]} " == *" ${name} "* ]]
}

# @description Run a command when its phase is enabled, printing the label
# before it and the label with the duration after it.
# @arg $1 string Phase name
# @arg $2 string Label
# @arg $@ string Command to run
installer::phase() {
  local usage="Usage: installer::phase <phase> <label> <command>..."

  if [ $# -lt 3 ] || [ -z "$1" ] || [ -z "$2" ]; then
    log::error "${usage}"
    return 2
  fi

  installer::phase_enabled "$1" || return 0

  local label=$2
  local start=${SECONDS}

  shift 2

  log::info "${label}..."
  "$@"
  log::info "${label} done in $((SECONDS - start))s"
}

# @description Print the package names of several profiles, without
# duplicates.
# @arg $@ string Profile folder names, then the repository types
# @internal
installer::_packages() {
  local profiles=()
  local types=()
  local argument

  for argument in "$@"; do
    case "${argument}" in
    core | extra | multilib | aur | external) types+=("${argument}") ;;
    *) profiles+=("${argument}") ;;
    esac
  done

  local profile

  for profile in "${profiles[@]}"; do
    profile::packages_by_repository_type "${profile}" "${types[@]}"
  done | sort -u
}

# @description Run the install phases of a profile and of the profiles it
# includes, the included ones first.
# @arg $1 string Profile folder name
# @exitcode 1 yay, dkms or kernel headers missing, or an unknown profile
installer::install_profile() {
  local usage="Usage: installer::install_profile <profile>"
  local machine=${1:-}

  if [ -z "${machine}" ]; then
    log::error "${usage}"
    return 2
  fi

  local chain profiles

  chain=$(profile::chain "${machine}") || return 1

  mapfile -t profiles <<<"${chain}"

  log::debug "Profiles: ${profiles[*]}"

  local base=false

  if [[ " ${profiles[*]} " == *" base "* ]]; then
    base=true
  fi

  local start official_packages aur_packages kernel profile

  if installer::_packages "${profiles[@]}" \
    core extra multilib aur external | grep -q -- '-dkms'; then
    if ! pacman -Q dkms &>/dev/null; then
      log::error "dkms is missing, run ${arch_setup_dir}/install.sh first"
      return 1
    fi

    for kernel in linux linux-lts; do
      if pacman -Q "${kernel}" &>/dev/null &&
        ! pacman -Q "${kernel}-headers" &>/dev/null; then
        log::error "${kernel}-headers is missing, required by the DKMS drivers"
        return 1
      fi
    done
  fi

  if [ "${base}" = true ]; then
    installer::phase pre "Setup system" "${arch_setup_dir:?}/os/setup.sh"
  fi

  if installer::phase_enabled packages; then
    mapfile -t official_packages < <(
      installer::_packages "${profiles[@]}" core extra multilib
    )

    if [ ${#official_packages[@]} -gt 0 ]; then
      start=${SECONDS}
      log::info "Installing ${machine} official packages..."
      log::debug "Official packages: ${official_packages[*]}"
      sudo pacman -Syu --needed --noconfirm "${official_packages[@]}" >/dev/null
      log::info "Installing ${machine} official packages done in $((SECONDS - start))s"
    fi
  fi

  for profile in "${profiles[@]}"; do
    installer::phase external "Installing ${profile} external packages" \
      profile::run_scripts "${profile}" install
  done

  if installer::phase_enabled aur; then
    mapfile -t aur_packages < <(
      installer::_packages "${profiles[@]}" aur
    )

    if [ ${#aur_packages[@]} -gt 0 ]; then
      if ! command -v yay &>/dev/null; then
        log::error "yay is missing, run ${arch_setup_dir}/install.sh first"
        return 1
      fi

      start=${SECONDS}
      log::info "Installing ${machine} AUR packages..."
      log::debug "AUR packages: ${aur_packages[*]}"
      yay -S --needed --noconfirm "${aur_packages[@]}" >/dev/null
      log::info "Installing ${machine} AUR packages done in $((SECONDS - start))s"
    fi
  fi

  for profile in "${profiles[@]}"; do
    installer::phase setups "Setup ${profile} packages" \
      profile::run_scripts "${profile}" setup
  done

  if [ "${base}" = true ]; then
    installer::phase resources "Installing fonts" font::install_external
  fi
}

# @description Finish an installation: apply the themes when asked and
# regenerate the GRUB config.
# @noargs
installer::finish() {
  installer::phase themes "Setup themes" theme::apply

  log::info "Updating GRUB config..."
  grub::update_config

  log::info "Installation finished in $((SECONDS - installer_start))s"
}
