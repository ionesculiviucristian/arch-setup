# shellcheck shell=bash

# Exports the environment of the Plasma session the guest logs into, so that the
# theme tools reach its bus from a Guest Control process, which has none.
session_pid=$(pgrep -u "${USER}" -x plasmashell | head -1 || true)

if [ -n "${session_pid}" ]; then
  while IFS= read -r variable; do
    export "${variable?}"
  done < <(tr '\0' '\n' </proc/"${session_pid}"/environ |
    grep -E '^(DBUS_SESSION_BUS_ADDRESS|DISPLAY|WAYLAND_DISPLAY|XDG_CURRENT_DESKTOP|XDG_RUNTIME_DIR|XDG_SESSION_TYPE)=')
fi
