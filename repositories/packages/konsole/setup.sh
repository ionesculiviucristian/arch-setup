#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

konsole_dir="${HOME}/.local/share/konsole"
konsole_profile="Starship.profile"

mkdir -p "${konsole_dir}"

cp \
  "${root_dir}/repositories/packages/konsole/config/${konsole_profile}" \
  "${konsole_dir}/${konsole_profile}"

kwriteconfig6 \
  --file "${HOME}/.config/konsolerc" \
  --group "Desktop Entry" \
  --key "DefaultProfile" \
  "${konsole_profile}"

exit 0
