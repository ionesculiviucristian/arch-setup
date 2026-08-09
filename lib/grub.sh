# shellcheck shell=bash

# @description Add kernel parameters to GRUB.
# @arg $@ string Kernel parameters
grub::add_parameters() {
  local usage="Usage: grub::add_parameters <parameter>..."

  if [ $# -eq 0 ]; then
    log::error "${usage}"
    return 2
  fi

  local grub_file="/etc/default/grub"
  local parameter

  for parameter in "$@"; do
    if ! sudo grep -Eq "^GRUB_CMDLINE_LINUX_DEFAULT=.*[\" ]${parameter}[\" ]" "${grub_file}"; then
      file::replace_text --sudo \
        '^GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"' \
        "GRUB_CMDLINE_LINUX_DEFAULT=\"\1 ${parameter}\"" \
        "${grub_file}"
    fi
  done
}

# @description Regenerate grub.cfg from /etc/default/grub.
# @noargs
grub::update_config() {
  sudo grub-mkconfig -o "/boot/grub/grub.cfg" >/dev/null
}
