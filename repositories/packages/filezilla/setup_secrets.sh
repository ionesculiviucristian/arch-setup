#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../scripts/secrets.sh
source "${root_dir}/scripts/secrets.sh"

filezilla_config_dir="${HOME}/.config/filezilla"

mkdir -p "${filezilla_config_dir}"
read_secret "FTP hosts" >"${filezilla_config_dir}/sitemanager.xml"

exit 0
