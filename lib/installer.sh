# shellcheck shell=bash

installer_phases=()
installer_themes=false
installer_start=${SECONDS}

# @description Send stdout and stderr to <prefix>_<name>.log and
# <prefix>_errors_<name>.log in the root of the repository being installed,
# and debug messages on fd 4 to <prefix>_<name>.log.
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

  local dir="${arch_setup_dirs[0]:?}"

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

  local arg

  installer_phases=()
  installer_themes=false

  for arg in "$@"; do
    case "${arg}" in
    --themes) installer_themes=true ;;
    --debug) export ARCH_SETUP_DEBUG=1 ;;
    pre | packages | external | aur | setups | resources | themes) installer_phases+=("${arg}") ;;
    *)
      log::error "${usage}"
      return 2
      ;;
    esac
  done

  log::debug "Profile: ${profile}, phases: ${installer_phases[*]:-all}, themes: ${installer_themes}"

  installer::redirect_logs install "${profile}"

  install -D -m 644 /dev/stdin "${HOME}/.local/state/arch-setup/dir" <<<"${arch_setup_dir}"

  if [ "${arch_setup_dirs[0]}" != "${arch_setup_dir}" ] &&
    ! grep -qxF "${arch_setup_dirs[0]}" "${arch_setup_repositories_file:?}" 2>/dev/null; then
    echo "${arch_setup_dirs[0]}" >>"${arch_setup_repositories_file}"
  fi

  trap 'sudo sed -i "/# arch-setup$/d" /etc/pacman.conf; sudoers::disable_passwordless' EXIT

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

  local dir

  for dir in "${arch_setup_dir}" "${arch_setup_dirs[0]}"; do
    if [ ! -f "${dir}/.env" ] && [ -f "${dir}/.env.example" ]; then
      cp "${dir}/.env.example" "${dir}/.env"
    fi
  done
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

# @description Run the packages, external, aur and setups phases of a profile.
# @arg $1 string Profile folder name
# @exitcode 1 yay, dkms or kernel headers missing
installer::install_profile() {
  local usage="Usage: installer::install_profile <profile>"
  local machine=${1:-}

  if [ -z "${machine}" ]; then
    log::error "${usage}"
    return 2
  fi

  local start official_packages aur_packages kernel

  if profile::packages_by_repository_type "${machine}" core extra multilib aur external | grep -q -- '-dkms'; then
    if ! pacman -Q dkms &>/dev/null; then
      log::error "dkms is missing, run ${arch_setup_dir}/install.sh first"
      return 1
    fi

    for kernel in linux linux-lts; do
      if pacman -Q "${kernel}" &>/dev/null && ! pacman -Q "${kernel}-headers" &>/dev/null; then
        log::error "${kernel}-headers is missing, required by the DKMS drivers"
        return 1
      fi
    done
  fi

  if installer::phase_enabled packages; then
    start=${SECONDS}
    log::info "Installing ${machine} official packages..."
    official_packages=$(profile::packages_by_repository_type "${machine}" core extra multilib)
    log::debug "Official packages: ${official_packages//$'\n'/ }"
    # shellcheck disable=SC2086
    sudo pacman \
      -Syu \
      --needed \
      --noconfirm \
      ${official_packages} >/dev/null
    log::info "Installing ${machine} official packages done in $((SECONDS - start))s"
  fi

  if installer::phase_enabled external; then
    start=${SECONDS}
    log::info "Installing ${machine} external packages..."
    profile::run_scripts "${machine}" install
    log::info "Installing ${machine} external packages done in $((SECONDS - start))s"
  fi

  aur_packages=$(profile::packages_by_repository_type "${machine}" aur)

  if installer::phase_enabled aur && [ -n "${aur_packages}" ]; then
    if ! command -v yay &>/dev/null; then
      log::error "yay is missing, run ${arch_setup_dir}/install.sh first"
      return 1
    fi

    start=${SECONDS}
    log::info "Installing ${machine} AUR packages..."
    log::debug "AUR packages: ${aur_packages//$'\n'/ }"
    # shellcheck disable=SC2086
    yay \
      -S \
      --needed \
      --noconfirm \
      ${aur_packages} >/dev/null
    log::info "Installing ${machine} AUR packages done in $((SECONDS - start))s"
  fi

  if installer::phase_enabled setups; then
    start=${SECONDS}
    log::info "Setup ${machine} packages..."
    profile::run_scripts "${machine}" setup
    log::info "Setup ${machine} packages done in $((SECONDS - start))s"
  fi
}

# @description Finish an installation: apply the themes when asked and
# regenerate the GRUB config.
# @noargs
installer::finish() {
  local start

  if installer::phase_enabled themes; then
    start=${SECONDS}
    log::info "Setup themes..."
    theme::apply
    log::info "Setup themes done in $((SECONDS - start))s"
  fi

  log::info "Updating GRUB config..."
  grub::update_config

  log::info "Installation finished in $((SECONDS - installer_start))s"
}
