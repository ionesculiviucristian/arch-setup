#!/bin/bash
set -eu

# @description Run the installer of a profile from profiles/.
# @arg $1 string Profile folder name (optional, default: base)
# @arg $@ string Arguments passed to the profile installer: --themes, and the base install phases

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

profile="base"

if [ $# -gt 0 ] && [[ "$1" != -* ]]; then
  profile=$1
  shift
fi

profile_installer="${root_dir}/profiles/${profile}/install.sh"

if [ ! -x "${profile_installer}" ]; then
  echo "Error: Unknown profile ${profile}" >&2
  exit 1
fi

exec "${profile_installer}" "$@"
