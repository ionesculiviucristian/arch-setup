#!/bin/bash
set -eu

info() {
  echo "$@" >/dev/tty
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

enable_passwordless_sudo() {
  # shellcheck disable=SC2155
  local passwordless_sudo_file="/etc/sudoers.d/$(whoami)"

  sudo rm -f "${passwordless_sudo_file}"

  echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" | \
    sudo tee "${passwordless_sudo_file}" >/dev/null
}

disable_passwordless_sudo() {
  # shellcheck disable=SC2155
  sudo rm -f "/etc/sudoers.d/$(whoami)"
}
