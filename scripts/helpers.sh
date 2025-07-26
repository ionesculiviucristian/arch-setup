#!/bin/bash
set -eu

INDENT="${1:-0}"

_cp() {
  show_message "📄 Copying file(s) $1 to $2 ..."
  cp "$1" "$2"
}

_cp_sudo() {
  show_message "⚠️📄 Copying file(s) $1 to $2 using sudo..."
  sudo cp "$1" "$2"
}

_cp_r() {
  show_message "📁 Copying directory $1 to $2 ..."
  cp -r "$1" "$2"
}

_cp_r_sudo() {
  show_message "⚠️📁 Copying directory $1 to $2 using sudo..."
  sudo cp -r "$1" "$2"
}

_mkdir() {
  show_message "📁 Creating directory $1 ..."
  mkdir -p "$1"
}

_mkdir_sudo() {
  show_message "⚠️📁 Creating directory $1 using sudo..."
  sudo mkdir -p "$1"
}

_rmd() {
  show_message "📁 Removing directory $1 ..."
  rm -rf "$1"
}

_rmdir_sudo() {
  show_message "⚠️📁 Removing directory $1 using sudo ..."
  sudo rm -rf "$1"
}

_rmf() {
  show_message "📄 Removing file $1 ..."
  rm -f "$1"
}

_rmf_sudo() {
  show_message "📄 Removing file $1 using sudo..."
  sudo rm -f "$1"
}

download() {
  show_message "📥 Downloading $2 to $1 ..."
  wget -qO "$1" "$2"
}

git_clone() {
  show_message "🧬 Cloning $1 in $2..."
  git clone -q "$1" "$2"
}

inform() {
  show_message "💬 $1 ..."
}

inform_install() {
  show_message "🚀 Installing $1 ..."
}

inform_setup() {
  show_message "⚙️ Setting up $1 ..."
}

log() {
  "$@" 2>&1 | tee -a "./install.log"
}

service_enable() {
  show_message "⚡️ Enabling service $1 ..."
  sudo systemctl enable "$1"
}

service_start() {
  show_message "⚡️ Starting service $1 ..."
  sudo systemctl start "$1"
}

show_message() {
  local indent=""
  for ((i=0; i<INDENT; i++)); do
    indent+=" "
  done
  echo "${indent}$*"
}
