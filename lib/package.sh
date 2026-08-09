# shellcheck shell=bash

# @description Print a definition's repository: core, extra, multilib, aur or external.
# @arg $1 string Path to the definition .yml
# @exitcode 1 Unknown repository.url
package::repository_type() {
  local usage="Usage: package::repository_type <definition yml>"
  local yml=${1:-}

  if [ -z "${yml}" ]; then
    log::error "${usage}"
    return 2
  fi

  local url
  url=$(yq -r '.repository.url // ""' "${yml}")

  case "${url}" in
  "") echo "external" ;;
  https://aur.archlinux.org/packages/*) echo "aur" ;;
  https://archlinux.org/packages/*)
    url=${url#https://archlinux.org/packages/}
    echo "${url%%/*}"
    ;;
  *)
    log::error "Unknown repository.url ${url} in ${yml}"
    return 1
    ;;
  esac
}

# @description Print a definition's package name.
# @arg $1 string Path to the definition .yml
package::name() {
  local usage="Usage: package::name <definition yml>"
  local yml=${1:-}

  if [ -z "${yml}" ]; then
    log::error "${usage}"
    return 2
  fi

  local url
  url=$(yq -r '.repository.url // ""' "${yml}")

  if [ -n "${url}" ]; then
    url=${url%/}
    echo "${url##*/}"
  elif [ "$(basename "${yml}")" = "package.yml" ]; then
    basename "$(dirname "${yml}")"
  else
    basename "${yml}" .yml
  fi
}

# @description Print the folder of a package or driver.
# @arg $1 string Package or driver folder name
# @internal
package::_dir() {
  local name=$1
  local dir base

  for dir in "${arch_setup_dirs[@]:?}"; do
    for base in "${dir}/repositories/packages" "${dir}/repositories/drivers"; do
      if [ -d "${base}/${name}" ]; then
        echo "${base}/${name}"
        return
      fi
    done
  done
}
