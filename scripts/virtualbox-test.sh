#!/bin/bash
set -eu

# @description Test install.sh in a VirtualBox VM: restore a snapshot, copy the working tree with mounts.example.json as mounts.json, run install.sh and copy the logs to vm-logs/.
# @option --config <file> VM config with the VM name and the snapshot to restore (default: scripts/virtualbox/virtualbox.yml)
# @option --create <iso> Create the VM from the config first, installing Arch Linux unattended from the ISO with archinstall/user_configuration.json
# @option --keep Leave the VM running after the test
# @arg $@ string Arguments passed to install.sh, after --
# @see [manual](https://www.virtualbox.org/manual/topics/vboxmanage.html)
# @see [config](https://github.com/archlinux/archinstall/tree/master/examples)
# @see [cloud-init](https://docs.cloud-init.io/en/latest/reference/datasources/nocloud.html)

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=SCRIPTDIR/../lib/index.sh
source "${root_dir}/lib/index.sh"
# shellcheck source=SCRIPTDIR/virtualbox/virtualbox.sh
source "${root_dir}/scripts/virtualbox/virtualbox.sh"

usage="Usage: scripts/virtualbox-test.sh [--config <file>] [--create <iso>] [--keep] [-- install.sh arguments...]"
config="${root_dir}/scripts/virtualbox/virtualbox.yml"
iso=""
keep=false
install_args=()

while [ $# -gt 0 ]; do
  case "$1" in
  --config)
    [ $# -ge 2 ] || {
      log::error "${usage}"
      exit 2
    }
    config=$2
    shift 2
    ;;
  --create)
    [ $# -ge 2 ] || {
      log::error "${usage}"
      exit 2
    }
    iso=$2
    shift 2
    ;;
  --keep)
    keep=true
    shift
    ;;
  --)
    shift
    install_args=("$@")
    break
    ;;
  *)
    log::error "${usage}"
    exit 2
    ;;
  esac
done

if [ ! -f "${config}" ] || { [ -n "${iso}" ] && [ ! -f "${iso}" ]; }; then
  log::error "${usage}"
  exit 2
fi

vm=$(virtualbox::config "${config}" general.name)
snapshot=$(virtualbox::config "${config}" snapshot)
password=$(virtualbox::config "${config}" guest.password)
user=$(virtualbox::config "${config}" guest.user)

if [ -n "${iso}" ]; then
  virtualbox::create "${config}" "${iso}"
fi

guest_home="/home/${user}"
guest_repo="${guest_home}/Projects/arch-setup"
guest_session="/tmp/session.sh"
logs_dir="${root_dir}/vm-logs/${vm}-$(date +%Y%m%d-%H%M%S)"
tmp_dir=$(mktemp -d)
trap 'rm -rf "${tmp_dir}"' EXIT

guest() {
  VBoxManage guestcontrol "${vm}" "$1" \
    --username "${user}" \
    --password "${password}" \
    "${@:2}"
}

guest_bash() {
  guest run \
    --exe /bin/bash \
    --putenv "HOME=${guest_home}" \
    --putenv "USER=${user}" \
    -- -lc "source ${guest_session} && $1"
}

log::info "Cutting the power of ${vm}, the snapshot is restored over it anyway..."
virtualbox::power_off "${vm}"

log::info "Restoring snapshot ${snapshot}..."
VBoxManage snapshot "${vm}" restore "${snapshot}"

log::info "Starting ${vm}..."
VBoxManage startvm "${vm}" --type headless >/dev/null

log::info "Waiting for the Guest Additions..."
wait_start=${SECONDS}
until guest run --exe /bin/true --timeout 10000 &>/dev/null; do
  if [ $((SECONDS - wait_start)) -gt 300 ]; then
    log::error "${vm} did not answer within 300s; check the Guest Additions and the user ${user}"
    exit 1
  fi
  sleep 5
done

guest copyto --target-directory "${guest_session}" "${root_dir}/scripts/virtualbox/session.sh"

log::info "Copying the working tree..."
git -C "${root_dir}" ls-files --cached --others --exclude-standard -z |
  tar --directory "${root_dir}" --null --files-from - --ignore-failed-read --create --gzip --file "${tmp_dir}/arch-setup.tar.gz"
guest copyto --target-directory /tmp/arch-setup.tar.gz "${tmp_dir}/arch-setup.tar.gz"
guest_bash "rm -rf '${guest_repo}' && mkdir -p '${guest_repo}' && tar --extract --gzip --file /tmp/arch-setup.tar.gz --directory '${guest_repo}' && cp '${guest_repo}/mounts.example.json' '${guest_repo}/mounts.json'"

install_command="'${guest_repo}/install.sh'"
if [ ${#install_args[@]} -gt 0 ]; then
  install_command+=" $(printf '%q ' "${install_args[@]}")"
fi

log::info "Running install.sh ${install_args[*]}..."
status=0
guest_bash "${install_command}" || status=$?

log::info "Copying the logs to ${logs_dir}..."
mkdir -p "${logs_dir}"
guest_bash "cd '${guest_repo}' && tar --create --gzip --file /tmp/arch-setup-logs.tar.gz *.log"
guest copyfrom --target-directory "${tmp_dir}/arch-setup-logs.tar.gz" /tmp/arch-setup-logs.tar.gz
tar --extract --gzip --file "${tmp_dir}/arch-setup-logs.tar.gz" --directory "${logs_dir}"

if [ "${keep}" = false ]; then
  log::info "Shutting ${vm} down..."
  virtualbox::power_off --shutdown "${vm}"
fi

if [ "${status}" -ne 0 ]; then
  log::error "install.sh failed with ${status}, logs in ${logs_dir}"
  exit 1
fi

log::info "install.sh passed, logs in ${logs_dir}"

exit 0
