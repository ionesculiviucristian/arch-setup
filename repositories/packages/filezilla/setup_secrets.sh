#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

# shellcheck source=../../../scripts/bitwarden.sh
source "${root_dir}/scripts/bitwarden.sh"

filezilla_dir="${HOME}/.config/filezilla"

mkdir -p "${filezilla_dir}"
read_bitwarden_entry "FTP hosts" >"${filezilla_dir}/sitemanager.xml"

exit 0
