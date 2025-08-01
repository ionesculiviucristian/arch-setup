#!/bin/bash
set -eu

./scripts/update_bashrc.sh <<EOF
# Setup history
shopt -u histappend
HISTCONTROL=ignoreboth
HISTFILESIZE=100000
HISTSIZE=10000
EOF

./scripts/install_bash_aliases.sh

exit 0
