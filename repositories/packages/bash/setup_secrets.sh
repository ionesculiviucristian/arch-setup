#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

# shellcheck source=../../../scripts/bitwarden.sh
source "${root_dir}/scripts/bitwarden.sh"

read_bitwarden_entry "Private bash aliases" >"${HOME}/.bash_private_aliases"

exit 0
