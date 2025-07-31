#!/bin/bash
set -eu

extract_download() {
  wget -qO- "$1" | \
    bsdtar -xvf- -C "$2" >/dev/null
}

sudo_extract_download() {
  wget -qO- "$1" | \
    sudo bsdtar -xvf- -C >/dev/null
}
