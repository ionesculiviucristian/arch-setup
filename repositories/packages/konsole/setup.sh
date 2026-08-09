#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

konsole_dir="${HOME}/.local/share/konsole"
konsole_profile="Starship.profile"

mkdir -p "${konsole_dir}"

cp \
  "${package_dir}/config/${konsole_profile}" \
  "${konsole_dir}/${konsole_profile}"

kwriteconfig6 \
  --file "${HOME}/.config/konsolerc" \
  --group "Desktop Entry" \
  --key "DefaultProfile" \
  "${konsole_profile}"

exit 0
