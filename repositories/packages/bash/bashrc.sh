# shellcheck shell=bash
shopt -s histappend

HISTCONTROL=ignoreboth
HISTFILESIZE=100000
HISTSIZE=10000
HISTTIMEFORMAT='%F %T '

# shellcheck source=SCRIPTDIR/config/.bash_aliases
[ -f "${HOME}/.bash_aliases" ] && . "${HOME}/.bash_aliases"
