#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=SCRIPTDIR/../lib/index.sh
source "${root_dir}/lib/index.sh"

file::replace_text --sudo \
  '^#\[multilib\]' \
  '[multilib]' \
  "/etc/pacman.conf"

file::replace_text --sudo \
  --range '/^\[multilib\]/,/Include =/' \
  '^#Include = /etc/pacman.d/mirrorlist' \
  'Include = /etc/pacman.d/mirrorlist' \
  "/etc/pacman.conf"

install -D -m 644 \
  "${root_dir}/os/config/powerdevilrc" \
  "${HOME}/.config/powerdevilrc"

install -D -m 644 \
  "${root_dir}/os/config/environment.d/10-python.conf" \
  "${HOME}/.config/environment.d/10-python.conf"

kwriteconfig6 \
  --file "${HOME}/.config/kxkbrc" \
  --group "Layout" \
  --key "Options" \
  "caps:ctrl_modifier"

kwriteconfig6 \
  --file "${HOME}/.config/kxkbrc" \
  --group "Layout" \
  --key "ResetOldOptions" \
  --type "bool" \
  true

if ! grep -qs '/\.bashrc\.d/' "${HOME}/.bashrc"; then
  install -D -m 644 \
    "/etc/bash.bashrc" \
    "${HOME}/.bashrc"
fi

mkdir -p "${HOME}/.bash_aliases.d"
mkdir -p "${HOME}/.cache/arch-setup"
mkdir -p "${HOME}/.local/share/fonts"
mkdir -p "${HOME}/Backups/docker"
mkdir -p "${HOME}/Pictures/Wallpapers"
mkdir -p "${HOME}/Projects"

kde::add_user_place "${HOME}/Backups" "Backups"
kde::add_user_place "${HOME}/Projects" "Projects"

install -D -m 644 \
  --target-directory "${HOME}/Pictures/Wallpapers" \
  "${root_dir}/os/media/wallpapers/"*

if [ -n "$(file::find "mounts.json")" ]; then
  while read -r entry; do
    src=$(mounts::field "${entry}" "source")
    dest=$(mounts::field "${entry}" "destination")
    type=$(mounts::field "${entry}" "type")
    options=$(mounts::field "${entry}" "options")
    dump=$(mounts::field "${entry}" "dump")
    check=$(mounts::field "${entry}" "check")

    case "${src}" in
    SERIAL:* | UUID=*) ;;
    *)
      if [ ! -e "${src}" ]; then
        log::info "Source ${src} does not exist, skipping"
        continue
      fi
      ;;
    esac

    sudo mkdir -p "${dest}"

    fstab::add_entry \
      "${src}" \
      "${dest}" \
      "${type}" \
      "${options}" \
      "${dump}" \
      "${check}"
  done < <(mounts::list "system")

  sudo systemctl daemon-reload
  sudo mount -a
else
  log::info "mounts.json not found, skipping system mounts"
fi

exit 0
