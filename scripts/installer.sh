#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

info() {
  echo "$@" >/dev/tty
}

timed() {
  local label=$1
  shift
  local start=$SECONDS
  info "${label}..."
  "$@"
  info "${label} done in $(( SECONDS - start ))s"
}

extract_from_url() {
  local url=$1
  local path=$2

  if [ -z "${url}" ]; then
    echo "Error: URL is required"
    exit 1
  fi
  if [ -z "${path}" ]; then
    echo "Error: Path is required"
    exit 1
  fi

  wget -qO- "${url}" | bsdtar -xf- -C "${path}"
}

sudo_extract_from_url() {
  local url=$1
  local path=$2

  if [ -z "${url}" ]; then
    echo "Error: URL is required"
    exit 1
  fi
  if [ -z "${path}" ]; then
    echo "Error: Path is required"
    exit 1
  fi

  wget -qO- "${url}" | sudo bsdtar -xf- -C "${path}"
}

sudo_replace_text() {
  local pattern=$1
  local replacement=$2
  local file=$3
  local delimiter=${4:-"/"}

  if [ -z "${pattern}" ]; then
    echo "Error: Pattern is required"
    exit 1
  fi
  if [ -z "${replacement}" ]; then
    echo "Error: Replacement is required"
    exit 1
  fi
  if [ -z "${file}" ]; then
    echo "Error: File is required"
    exit 1
  fi

  sudo sed -i \
    "s${delimiter}${pattern}${delimiter}${replacement}${delimiter}" \
    "${file}"
}

disable_kernel_updates() {
  local pkgs=()

  sudo pacman -Sy >/dev/null

  for kernel in linux linux-lts; do
    if pacman -Q "$kernel" &>/dev/null; then
      pkgs+=("$kernel" "${kernel}-headers")
      sudo pacman -S --needed --noconfirm "${kernel}-headers" >/dev/null
    fi
  done

  if [[ ${#pkgs[@]} -gt 0 ]]; then
    sudo sed -i "/^\[options\]/a IgnorePkg = ${pkgs[*]} # arch-setup" /etc/pacman.conf
  fi
}

enable_kernel_updates() {
  sudo sed -i '/# arch-setup$/d' /etc/pacman.conf
}

enable_passwordless_sudo() {
  # shellcheck disable=SC2155
  local passwordless_sudo_file="/etc/sudoers.d/$(whoami)"

  sudo rm -f "${passwordless_sudo_file}"

  echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" |
    sudo tee "${passwordless_sudo_file}" >/dev/null
}

disable_passwordless_sudo() {
  # shellcheck disable=SC2155
  sudo rm -f "/etc/sudoers.d/$(whoami)"
}

read_mounts() {
  local key=$1
  jq -c ".${key}[]" "${root_dir}/mounts.json"
}

read_mount_field() {
  local entry=$1
  local field=$2
  echo "${entry}" | jq -r ".${field}"
}
