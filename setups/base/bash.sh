#!/bin/bash
set -eu

# [Config] https://www.gnu.org/software/bash/manual/bash.html

./scripts/update_bashrc.sh <<EOF
shopt -u histappend
HISTCONTROL=ignoreboth
HISTFILESIZE=100000
HISTSIZE=10000

if [ -f "${HOME}/.bash_aliases" ]; then
  . "${HOME}/.bash_aliases"
fi
EOF

./scripts/install_bash_aliases.sh

exit 0
