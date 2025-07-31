#!/bin/bash
set -eu

./scripts/update_bashrc.sh <<EOF
shopt -u histappend
HISTCONTROL=ignoreboth
HISTFILESIZE=10000
HISTSIZE=1000
EOF

./scripts/install_bash_aliases.sh

exit 0
