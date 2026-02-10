#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# shellcheck source=../../scripts/installer.sh
source "${root_dir}/scripts/installer.sh"

if [ ! -f "${root_dir}/mounts.json" ]; then
  info "mounts.json not found, skipping system mounts"
  exit 0
fi

while read -r entry; do
  src=$(read_mount_field "${entry}" "source")
  dest=$(read_mount_field "${entry}" "destination")
  type=$(read_mount_field "${entry}" "type")
  options=$(read_mount_field "${entry}" "options")
  dump=$(read_mount_field "${entry}" "dump")
  check=$(read_mount_field "${entry}" "check")

  case "${src}" in
  SERIAL:*) ;;
  *)
    if [ ! -e "${src}" ]; then
      info "Source ${src} does not exist, skipping"
      continue
    fi
    ;;
  esac

  sudo mkdir -p "${dest}"

  "${root_dir}/scripts/create_fstab_entry.sh" "${src}" "${dest}" "${type}" "${options}" "${dump}" "${check}"
done < <(read_mounts "system")

sudo systemctl daemon-reload
sudo mount -a

exit 0
