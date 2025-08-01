#!/bin/bash
set -eu

# https://github.com/akinomyoga/ble.sh?tab=readme-ov-file#13-set-up-bashrc
# https://github.com/akinomyoga/ble.sh/blob/master/blerc.template

basrc_file="${HOME}/.bashrc"

cp \
  "./configs/.blerc" \
  "${HOME}/.blerc"

lines=$(cat <<'EOF'

# Load ble.sh
[[ $- == *i* ]] && source -- "/usr/share/blesh/ble.sh" --attach=none --rcfile "${HOME}/.blerc"
EOF
)

if grep -Pzoq "$(printf '%s' "${lines}")" "${basrc_file}"; then
  exit 0
fi

sed -i "/\[\[ \$- != \*i\* \]\] && return/r /dev/stdin" \
  "${basrc_file}" <<<"${lines}"

exit 0
