#!/bin/bash
set -eu

# [config] https://www.gnu.org/software/bash/manual/bash.html

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

cp \
  "${root_dir}/repositories/packages/bash/config/.bash_aliases" \
  "${HOME}/.bash_aliases"

cp \
  "${root_dir}/repositories/packages/bash/config/.bash_aliases_help" \
  "${HOME}/.bash_aliases_help"

"${root_dir}/scripts/update_bashrc.sh" "bash" <<EOF
shopt -u histappend
HISTCONTROL=ignoreboth
HISTFILESIZE=100000
HISTSIZE=10000

[ -f "\${HOME}/.bash_aliases" ] && . "\${HOME}/.bash_aliases"
EOF

exit 0
