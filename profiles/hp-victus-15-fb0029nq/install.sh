#!/bin/bash
set -eu

# @description Run every install phase of the profile, or only the given ones; themes only with --themes or the themes phase.
# @option --themes Apply the themes after the other phases
# @option --debug Print debug messages, same as ARCH_SETUP_DEBUG=1
# @arg $@ string Phases: packages, external, aur, setups, themes (optional)

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# shellcheck source=SCRIPTDIR/../../lib/index.sh
source "${root_dir}/lib/index.sh"

installer::start hp-victus-15-fb0029nq "$@"

installer::install_profile hp-victus-15-fb0029nq

installer::finish

exit 0
