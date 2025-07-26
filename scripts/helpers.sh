#!/bin/bash
set -eu

INDENT="${1:-0}"

download() {
  show_message "🛜  Downloading $2 to $1 ..."
  wget -qO "$1" "$2"
}

copy() {
  show_message "📁 Copying $1 to $2 ..."
  cp "$1" "$2"
}

copy_r() {
  show_message "📁 Copying $1 to $2 ..."
  cp -r "$1" "$2"
}

info_msg() {
  show_message "ℹ️ $1 ..."
}

install_msg() {
  show_message "🚀 Installing $1 ..."
}

setup_msg() {
  show_message "⚙️ Setting up $1 ..."
}

show_message() {
  local indent=""
  for ((i=0; i<INDENT; i++)); do
    indent+=" "
  done
  echo "${indent}$*"
}
