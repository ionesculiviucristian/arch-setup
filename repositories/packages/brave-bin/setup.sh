#!/bin/bash
set -eu

# @see [wiki](https://wiki.archlinux.org/title/Chromium#Making_flags_persistent)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

install -D -m 644 \
  "${package_dir}/config/brave-flags.conf" \
  "${HOME}/.config/brave-flags.conf"

exit 0
