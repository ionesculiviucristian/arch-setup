# shellcheck shell=bash

# @description Add an /etc/fstab entry.
# @arg $1 string Source: directory, UUID=<uuid> or SERIAL:<serial>:<partition>
# @arg $2 string Destination directory
# @arg $3 string Filesystem type
# @arg $4 string Mount options
# @arg $5 number Dump (optional, default: 0)
# @arg $6 number Fsck order (optional, default: 0)
# @exitcode 1 Device not found or directory missing
fstab::add_entry() {
  local usage="Usage: fstab::add_entry <source> <destination> <type> <options> [dump] [check]"
  local src=${1:-}
  local dest=${2:-}
  local type=${3:-}
  local options=${4:-}
  local dump=${5:-0}
  local check=${6:-0}

  if [ -z "${src}" ] || [ -z "${dest}" ] || [ -z "${type}" ] || [ -z "${options}" ]; then
    log::error "${usage}"
    return 2
  fi

  case "${src}" in
  SERIAL:*)
    local serial partition dev_names part_uuid
    serial=$(echo "${src}" | cut -d: -f2)
    partition=$(echo "${src}" | cut -d: -f3)

    dev_names=$(lsblk --nodeps --noheadings --output NAME,SERIAL | awk -v serial="${serial}" '$2 == serial { print $1 }')

    if [ -z "${dev_names}" ]; then
      log::error "Device with serial '${serial}' not found. Is it plugged in?"
      return 1
    fi

    if [ "$(wc -l <<<"${dev_names}")" -ne 1 ]; then
      log::error "More than one device with serial '${serial}': ${dev_names//$'\n'/ }"
      return 1
    fi

    part_uuid=$(lsblk --list --noheadings --output UUID,PARTN "/dev/${dev_names}" | awk -v partition="${partition}" '$2 == partition { print $1 }')

    if [ -z "${part_uuid}" ]; then
      log::error "Could not find UUID on partition ${partition} of ${dev_names}. Is it formatted?"
      return 1
    fi

    src="UUID=${part_uuid}"
    log::debug "Serial ${serial} partition ${partition} resolved to /dev/${dev_names} ${src}"
    ;;
  esac

  if [ ! -d "${dest}" ]; then
    log::error "Destination directory does not exist: ${dest}"
    return 1
  fi

  case "${src}" in
  UUID=*) ;;
  *)
    if [ ! -d "${src}" ]; then
      log::error "Source directory does not exist: ${src}"
      return 1
    fi
    ;;
  esac

  local fstab_file="/etc/fstab"
  local src_escaped dest_escaped
  src_escaped=$(printf '%s' "${src}" | sed 's/ /\\040/g; s/\t/\\011/g')
  dest_escaped=$(printf '%s' "${dest}" | sed 's/ /\\040/g; s/\t/\\011/g')

  local fstab_entry="${src_escaped}  ${dest_escaped}  ${type}  ${options}  ${dump}  ${check}"

  if grep -qF "${src_escaped}  ${dest_escaped}" "${fstab_file}"; then
    log::debug "fstab entry already present: ${src_escaped} ${dest_escaped}"
  else
    log::debug "Adding fstab entry: ${fstab_entry}"
    echo "${fstab_entry}" | sudo tee -a "${fstab_file}" >/dev/null
  fi
}
