#!/bin/bash
set -eu

# KWin scripts from os/config/kwin:
#   knob-desk-focus - double Escape (double-esc.service): minimize desktop 2, switch to desktop 1, maximize Firefox there
#   desk2-lock      - password dialog (desk2-auth.service) before switching to desktop 2

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
scripts_dir="${HOME}/.local/share/kwin/scripts"

mkdir -p "${scripts_dir}"

for script_path in "${root_dir}/os/config/kwin/"*/; do
  script_id="$(basename "${script_path}")"

  rm -rf "${scripts_dir:?}/${script_id}"
  cp -r "${script_path}" "${scripts_dir}/${script_id}"

  kwriteconfig6 \
    --file "${HOME}/.config/kwinrc" \
    --group "Plugins" \
    --key "${script_id}Enabled" \
    --type "bool" \
    true
done

# desk2-auth.service: password dialog started by desk2-lock
# double-esc.service: double Escape runs knob-desk-focus
knob_bin="${scripts_dir}/knob-desk-focus/contents/bin"
gcc -O2 -o "${knob_bin}/double-esc" "${knob_bin}/double-esc.c"
mkdir -p "${HOME}/.config/systemd/user"
cp "${root_dir}/os/config/systemd/user/"*.service "${HOME}/.config/systemd/user/"
systemctl --user daemon-reload || true
systemctl --user enable double-esc.service || true
systemctl --user restart double-esc.service || true

# Apply to the running session, if any
if qdbus6 org.kde.KWin /KWin org.kde.KWin.currentDesktop >/dev/null 2>&1; then
  for script_path in "${root_dir}/os/config/kwin/"*/; do
    qdbus6 org.kde.KWin /Scripting org.kde.kwin.Scripting.unloadScript "$(basename "${script_path}")" >/dev/null || true
  done
  qdbus6 org.kde.KWin /KWin reconfigure
fi

exit 0
