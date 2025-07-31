#!/bin/bash
set -eu

# https://github.com/akinomyoga/ble.sh?tab=readme-ov-file#13-set-up-bashrc
# https://github.com/akinomyoga/ble.sh/blob/master/blerc.template

cp \
  "./configs/.blerc" \
  "${HOME}/.blerc"

lines=$(cat <<'EOF'

# Load ble.sh
[[ $- == *i* ]] && \
source -- "/usr/share/blesh/ble.sh" --attach=none --rcfile "${HOME}/.blerc"
EOF
)

if grep -Pzoq "$(printf '%s' "$lines")" "${HOME}/.bashrc"; then
  exit 0
fi

sed -i "/\[\[ \$- != \*i\* \]\] && return/r /dev/stdin" \
  "${HOME}/.bashrc" <<<"${lines}"

exit 0
