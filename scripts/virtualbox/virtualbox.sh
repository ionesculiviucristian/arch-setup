# shellcheck shell=bash

virtualbox_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# @description Print a value of a VM config.
# @arg $1 string Path to the VM config, e.g. scripts/virtualbox/virtualbox.yml
# @arg $2 string Key, e.g. general.name or snapshot
virtualbox::config() {
  local usage="Usage: virtualbox::config <config> <key>"
  local config=${1:-}
  local key=${2:-}

  if [ -z "${config}" ] || [ -z "${key}" ]; then
    log::error "${usage}"
    return 2
  fi

  yq --unwrapScalar ".${key}" "${config}"
}

# @description Print the state of a VirtualBox VM, e.g. running or poweroff.
# @arg $1 string VM name
# @exitcode 1 Unknown VM
virtualbox::state() {
  local usage="Usage: virtualbox::state <vm>"
  local vm=${1:-}

  if [ -z "${vm}" ]; then
    log::error "${usage}"
    return 2
  fi

  local info
  info=$(VBoxManage showvminfo "${vm}" --machinereadable) || return 1

  awk -F'"' '/^VMState=/ { print $2 }' <<<"${info}"
}

# @description Wait until a VirtualBox VM is powered off, cutting its power unless --shutdown or --wait is given.
# @arg $1 string VM name
# @option --shutdown Ask the guest to shut down with the ACPI power button, cutting the power after 120s
# @option --wait Wait for the guest to power itself off
virtualbox::power_off() {
  local usage="Usage: virtualbox::power_off [--shutdown|--wait] <vm>"
  local mode="cut"

  case "${1:-}" in
  --shutdown)
    mode="shutdown"
    shift
    ;;
  --wait)
    mode="wait"
    shift
    ;;
  esac

  local vm=${1:-}

  if [ -z "${vm}" ]; then
    log::error "${usage}"
    return 2
  fi

  local state
  state=$(virtualbox::state "${vm}") || return 1

  # Cutting the power loses whatever the guest has not written out yet, so the
  # default is only for a VM whose state is about to be thrown away anyway.
  if [ "${state}" = "running" ] && [ "${mode}" = "shutdown" ]; then
    VBoxManage controlvm "${vm}" acpipowerbutton
  elif [ "${mode}" != "wait" ] && { [ "${state}" = "running" ] || [ "${state}" = "paused" ]; }; then
    VBoxManage controlvm "${vm}" poweroff
    mode="cut"
  fi

  local shutdown_start=${SECONDS}

  while true; do
    case "$(virtualbox::state "${vm}")" in
    poweroff | aborted | saved) return 0 ;;
    esac

    if [ "${mode}" = "shutdown" ] && [ $((SECONDS - shutdown_start)) -gt 120 ]; then
      log::info "${vm} did not shut down within 120s, cutting its power..."
      VBoxManage controlvm "${vm}" poweroff
      mode="cut"
    fi

    sleep 1
  done
}

# @description Create a VirtualBox VM from a VM config, install Arch Linux unattended from an ISO and take the snapshot of the config.
# @arg $1 string Path to the VM config, e.g. scripts/virtualbox/virtualbox.yml
# @arg $2 string Arch Linux ISO
# @exitcode 1 The VM exists already, or the install failed or did not finish in time
virtualbox::create() {
  local usage="Usage: virtualbox::create <config> <iso>"
  local config=${1:-}
  local iso=${2:-}

  if [ ! -f "${config}" ] || [ ! -f "${iso}" ]; then
    log::error "${usage}"
    return 2
  fi

  local vm snapshot password user
  vm=$(virtualbox::config "${config}" general.name)
  snapshot=$(virtualbox::config "${config}" snapshot)
  password=$(virtualbox::config "${config}" guest.password)
  user=$(virtualbox::config "${config}" guest.user)

  local serials sizes types
  mapfile -t serials < <(yq '.storage.disks[].serial' "${config}")
  mapfile -t sizes < <(yq '.storage.disks[].size_mib' "${config}")
  mapfile -t types < <(yq '.storage.disks[].type' "${config}")

  if VBoxManage showvminfo "${vm}" &>/dev/null; then
    log::error "VM ${vm} already exists"
    return 1
  fi

  iso=$(realpath "${iso}")

  local disk_count=${#serials[@]}
  local iso_port=${disk_count}
  local seed_port=$((disk_count + 1))
  local install_timeout=5400
  local property="/arch-setup/install"

  log::info "Creating ${vm}..."
  VBoxManage createvm --name "${vm}" --ostype ArchLinux_64 --register >/dev/null

  local vm_dir
  vm_dir=$(dirname "$(VBoxManage showvminfo "${vm}" --machinereadable | awk -F'"' '/^CfgFile=/ { print $2 }')")

  if [ "$(stat --file-system --format %T "${vm_dir}")" = "btrfs" ]; then
    chattr +C "${vm_dir}"
  fi

  local accelerate_3d="off"
  if [ "$(virtualbox::config "${config}" display.accelerate_3d)" = "true" ]; then
    accelerate_3d="on"
  fi

  VBoxManage modifyvm "${vm}" \
    --cpus "$(virtualbox::config "${config}" system.cpus)" \
    --memory "$(virtualbox::config "${config}" system.memory_mib)" \
    --firmware efi \
    --graphicscontroller "$(virtualbox::config "${config}" display.graphics_controller)" \
    --vram "$(virtualbox::config "${config}" display.vram_mib)" \
    --accelerate-3d "${accelerate_3d}" \
    --clipboard-mode "$(virtualbox::config "${config}" general.clipboard)" \
    --drag-and-drop "$(virtualbox::config "${config}" general.drag_and_drop)" \
    --nic1 nat \
    --rtc-use-utc on \
    --mouse usbtablet \
    --audio-driver default \
    --audio-enabled on \
    --audio-out on

  VBoxManage storagectl "${vm}" --name SATA --add sata --controller IntelAhci --portcount $((disk_count + 2))

  # The guest sees the SATA ports in order, so port 0 is /dev/sda and archinstall
  # installs there; every other disk is partitioned and formatted by cloud-init.
  local letters="abcdefghijklmnop"
  local disk_commands=""
  local port disk_file device driver disk_command mount_dir directories directory

  for ((port = 0; port < disk_count; port++)); do
    disk_file="${vm_dir}/${vm}-disk${port}.vdi"

    VBoxManage createmedium disk \
      --filename "${disk_file}" \
      --size "${sizes[port]}" \
      --format VDI \
      --variant Standard >/dev/null

    VBoxManage storageattach "${vm}" --storagectl SATA --port "${port}" --device 0 --type hdd --medium "${disk_file}"
    VBoxManage setextradata "${vm}" "VBoxInternal/Devices/ahci/0/Config/Port${port}/SerialNumber" "${serials[port]}"

    if [ "${types[port]}" = "system" ]; then
      continue
    fi

    device="/dev/sd${letters:port:1}"
    mount_dir="/mnt/disk${port}"

    # The kernel driver is not always named after the filesystem, and mount has
    # to be told which one to use: blkid reports ntfs, the driver is ntfs3.
    case "${types[port]}" in
    ntfs)
      driver="ntfs3"
      disk_command="printf ',,\n' | sfdisk --label gpt ${device} && mkfs.ntfs --fast ${device}1"
      ;;
    *)
      log::error "Disk type ${types[port]} of ${config} is not supported"
      return 1
      ;;
    esac

    mapfile -t directories < <(yq ".storage.disks[${port}].directories[]?" "${config}")

    if [ "${#directories[@]}" -gt 0 ]; then
      disk_command+=" && mkdir -p ${mount_dir} && mount -t ${driver} ${device}1 ${mount_dir}"

      for directory in "${directories[@]}"; do
        disk_command+=" && mkdir -p '${mount_dir}/${directory}'"
      done

      disk_command+=" && umount ${mount_dir} && rmdir ${mount_dir}"
    fi

    # One command per disk: archinstall runs every custom command in its own
    # arch-chroot unit, so a mount does not survive into the next one.
    disk_commands+="${disk_command}"$'\n'
  done

  local seed_iso="${vm_dir}/seed.iso"

  log::info "Building the cloud-init seed..."
  (
    local seed_dir
    seed_dir=$(mktemp -d)
    trap 'rm -rf "${seed_dir}"' EXIT

    local mirrors archinstall_config creds runcmd
    mirrors=$(awk '/^Server/ { print $3 }' /etc/pacman.d/mirrorlist | head -n 5)

    archinstall_config=$(
      MIRRORS=${mirrors} VM_USER=${user} ROOT_MIB=$((sizes[0] - 1026)) DISK_COMMANDS=${disk_commands} yq --output-format json '
        .disk_config.device_modifications[0].partitions[1].size.value = (strenv(ROOT_MIB) | tonumber)
        | .mirror_config.custom_servers = (strenv(MIRRORS) | split("\n") | map(select(. != "")) | map({"url": .}))
        | .custom_commands += (strenv(DISK_COMMANDS) | split("\n") | map(select(. != "")))
        | .custom_commands += [
          "echo \"" + strenv(VM_USER) + " ALL=(ALL) NOPASSWD: ALL\" > /etc/sudoers.d/virtualbox-test",
          "chmod 440 /etc/sudoers.d/virtualbox-test"
        ]
      ' "${virtualbox_dir}/archinstall/user_configuration.json"
    )

    creds=$(
      VM_USER=${user} VM_PASSWORD=${password} ROOT_HASH=$(openssl passwd -6 -stdin <<<"${password}") yq --null-input --output-format json '
        .users = [{"username": strenv(VM_USER), "!password": strenv(VM_PASSWORD), "sudo": true, "groups": []}]
        | .root_enc_password = strenv(ROOT_HASH)
      '
    )

    runcmd="if archinstall --config /root/user_configuration.json --creds /root/user_credentials.json --silent --skip-version-check --no-pkg-lookups --skip-wkd; then VBoxControl --nologo guestproperty set ${property} done; sleep 30; poweroff; else VBoxControl --nologo guestproperty set ${property} failed; fi"

    echo "instance-id: ${vm}" >"${seed_dir}/meta-data"
    {
      echo "#cloud-config"
      CONFIG=${archinstall_config} CREDS=${creds} RUNCMD=${runcmd} yq --null-input '
        .write_files = [
          {"path": "/root/user_configuration.json", "content": strenv(CONFIG)},
          {"path": "/root/user_credentials.json", "content": strenv(CREDS), "permissions": "0600"}
        ]
        | .runcmd = [["bash", "-c", strenv(RUNCMD)]]
      '
    } >"${seed_dir}/user-data"

    umask 077
    bsdtar --format iso9660 --options 'iso9660:volume-id=CIDATA,joliet' --create --file "${seed_iso}" --directory "${seed_dir}" meta-data user-data
  ) || return 1

  VBoxManage storageattach "${vm}" --storagectl SATA --port "${iso_port}" --device 0 --type dvddrive --medium "${iso}"
  VBoxManage storageattach "${vm}" --storagectl SATA --port "${seed_port}" --device 0 --type dvddrive --medium "${seed_iso}"

  log::info "Starting ${vm}..."
  VBoxManage startvm "${vm}" --type headless >/dev/null

  log::info "Installing Arch Linux, open the VM in VirtualBox to watch..."
  local install_start=${SECONDS}
  local last_report=${SECONDS}
  local value

  while true; do
    value=$(VBoxManage guestproperty get "${vm}" "${property}")
    log::debug "${property}: ${value}"

    case "${value}" in
    "Value: done")
      break
      ;;
    "Value: failed")
      log::error "archinstall failed; ${vm} is still running, read /var/log/archinstall/install.log in it"
      return 1
      ;;
    esac

    if [ "$(virtualbox::state "${vm}")" = "poweroff" ]; then
      log::error "${vm} powered off before the install finished"
      return 1
    fi

    if [ $((SECONDS - install_start)) -gt "${install_timeout}" ]; then
      log::error "The install did not finish within ${install_timeout}s; ${vm} is still running"
      return 1
    fi

    if [ $((SECONDS - last_report)) -ge 60 ]; then
      log::info "  still installing, $((SECONDS - install_start))s"
      last_report=${SECONDS}
    fi

    sleep 10
  done

  log::info "Install finished in $((SECONDS - install_start))s, waiting for ${vm} to power off..."
  virtualbox::power_off --wait "${vm}"

  VBoxManage storageattach "${vm}" --storagectl SATA --port "${iso_port}" --device 0 --type dvddrive --medium none
  VBoxManage storageattach "${vm}" --storagectl SATA --port "${seed_port}" --device 0 --type dvddrive --medium none
  VBoxManage closemedium dvd "${seed_iso}" --delete

  log::info "Taking snapshot ${snapshot}..."
  VBoxManage snapshot "${vm}" take "${snapshot}" >/dev/null
}
