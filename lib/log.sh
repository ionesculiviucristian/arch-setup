# shellcheck shell=bash

# @description Print a message to the output saved as fd 3 before the log
# redirection.
# @arg $@ string Message
log::info() {
  echo "$@" >&3
}

# @description Print a debug message to fd 3 and to the log file on fd 4
# when ARCH_SETUP_DEBUG is 1.
# @arg $@ string Message
log::debug() {
  if [ "${ARCH_SETUP_DEBUG:-}" = "1" ]; then
    local message
    printf -v message '[%(%T)T] Debug: %s' -1 "$*"
    echo "${message}" >&3
    echo "${message}" >&4
  fi
}

# @description Print an error to stderr.
# @arg $@ string Message
log::error() {
  echo "Error: $*" >&2
}
