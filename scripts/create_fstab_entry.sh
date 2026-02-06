#!/bin/bash
set -eu

src=$1
dest=$2
type=$3
options=$4
dump=${5:-0}
check=${6:-0}

if [ -z "${src}" ]; then
  echo "Error: Source is required"
  exit 1
fi

if [ -z "${dest}" ]; then
  echo "Error: Destination is required"
  exit 1
fi

if [ -z "${type}" ]; then
  echo "Error: Type is required"
  exit 1
fi

if [ -z "${options}" ]; then
  echo "Error: Options is required"
  exit 1
fi

case "${src}" in
SERIAL:*)
  serial=$(echo "${src}" | cut -d: -f2)
  partition=$(echo "${src}" | cut -d: -f3)

  dev_name=$(lsblk -no NAME,SERIAL | grep "${serial}" | awk '{print $1}')

  if [ -z "${dev_name}" ]; then
    echo "Error: Device with serial '${serial}' not found. Is it plugged in?"
    exit 1
  fi

  part_uuid=$(lsblk -no UUID "/dev/${dev_name}${partition}")

  if [ -z "${part_uuid}" ]; then
    echo "Error: Could not find UUID on ${dev_name}${partition}. Is it formatted?"
    exit 1
  fi

  src="UUID=${part_uuid}"
  ;;
esac

if [ ! -d "${dest}" ]; then
  echo "Error: Destination directory does not exist: ${dest}"
  exit 1
fi

case "${src}" in
UUID=*) ;;
*)
  if [ ! -d "${src}" ]; then
    echo "Error: Source directory does not exist: ${src}"
    exit 1
  fi
  ;;
esac

fstab_file="/etc/fstab"

src_escaped=$(printf '%s' "${src}" | sed 's/ /\\040/g; s/\t/\\011/g')
dest_escaped=$(printf '%s' "${dest}" | sed 's/ /\\040/g; s/\t/\\011/g')

fstab_entry="${src_escaped}  ${dest_escaped}  ${type}  ${options}  ${dump}  ${check}"

if ! grep -qF "${src_escaped}  ${dest_escaped}" "${fstab_file}"; then
  echo "${fstab_entry}" | sudo tee -a "${fstab_file}" >/dev/null
fi

exit 0
